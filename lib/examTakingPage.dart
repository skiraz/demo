import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class SecondPage extends StatefulWidget {
  final Map<String, dynamic> exam;

  SecondPage({required this.exam});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late Timer _timer;
  int _remainingTime = 30 * 60; // 30 minutes in seconds
  String? _pdfPath;
  String _selectedQuestion = 'Question 1'; // Default selected question
  String?
      _selectedAnswer; // The selected answer for the currently selected question
  final Map<String, String?> _answers =
      {}; // Map to store answers for each question

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadPdf();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  Future<void> _loadPdf() async {
    try {
      final pdfPath = await loadPdfFromAssets(widget.exam["pdf"]);
      setState(() {
        _pdfPath = pdfPath;
      });
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final questions = List.generate(40, (index) => 'Question ${index + 1}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time Remaining: ${_formatTime(_remainingTime)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _pdfPath != null
                ? PDFView(filePath: _pdfPath)
                : Center(child: CircularProgressIndicator()),
          ),
          Divider(
            color: Colors.black,
            thickness: 3,
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedQuestion,
                    items: List.generate(widget.exam["Questions"], (index) {
                      final questionNumber = index + 1;
                      return DropdownMenuItem<String>(
                        value: 'Question $questionNumber',
                        child: Text(
                          'Question $questionNumber',
                        ),
                      );
                    }),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedQuestion = newValue!;
                        _selectedAnswer =
                            null; // Reset selected answer when changing question
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    menuMaxHeight:
                        200, // Set the maximum height of the dropdown menu
                  ),
                ),
                ListTile(
                  title: Text('Option A'),
                  leading: Radio<String>(
                    value: 'A',
                    groupValue: _answers[_selectedQuestion],
                    onChanged: (String? value) {
                      setState(() {
                        _answers[_selectedQuestion] =
                            value; // Save the answer for the current question
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Option B'),
                  leading: Radio<String>(
                    value: 'B',
                    groupValue: _answers[_selectedQuestion],
                    onChanged: (String? value) {
                      setState(() {
                        print(_answers);
                        _answers[_selectedQuestion] =
                            value; // Save the answer for the current question
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Option C'),
                  leading: Radio<String>(
                    value: 'C',
                    groupValue: _answers[_selectedQuestion],
                    onChanged: (String? value) {
                      setState(() {
                        _answers[_selectedQuestion] =
                            value; // Save the answer for the current question
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Option D'),
                  leading: Radio<String>(
                    value: 'D',
                    groupValue: _answers[_selectedQuestion],
                    onChanged: (String? value) {
                      setState(() {
                        _answers[_selectedQuestion] =
                            value; // Save the answer for the current question
                      });
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Go back to the previous screen
                      },
                      child: Text('Finish'),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> loadPdfFromAssets(pdf) async {
    final ByteData bytes = await rootBundle.load('assets/pdf/$pdf.pdf');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$pdf.pdf');

    await file.writeAsBytes(list, flush: true);

    print('PDF file path: ${file.path}');
    return file.path;
  }
}
