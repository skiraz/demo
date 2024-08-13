import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PDFViewerPage(),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: FutureBuilder<String>(
        future: loadPDF(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return PDFView(
                filePath: snapshot.data!,
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading PDF: ${snapshot.error}'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<String> loadPDF() async {
    try {
      // Load the PDF from assets

      final ByteData bytes = await rootBundle.load('assets/pdf/test.pdf');
      final Uint8List list = bytes.buffer.asUint8List();

      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/test.pdf');
      await file.writeAsBytes(list, flush: true);

      return file.path;
    } catch (e) {
      print(e);
      throw Exception('Error loading PDF: $e');
    }
  }
}
