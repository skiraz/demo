import 'package:flutter/material.dart';
import 'examTakingPage.dart'; // Import the SecondPage class
import 'locked_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _controller = TextEditingController();

  // Define a list of codes to compare against
  final List<String> _codes = ['12345', '67890', 'ABCDE', 'FGHIJ'];
  final Map exams = {
    '12345': {
      "Questions": 40,
      "Exam": "Physics",
      "Duration": 30,
      "StartTime": 11,
      "pdf": "exam1"
    },
    '67890': {"Questions": 30, "Exam": "Math", "Duration": 30, "StartTime": 11},
    'ABCDE': {
      "Questions": 20,
      "Exam": "finance",
      "Duration": 30,
      "StartTime": 11,
      "pdf": "exam2"
    },
    'FGHIJ': {
      "Questions": 10,
      "Exam": "history",
      "Duration": 30,
      "StartTime": 11,
      "pdf": "test"
    },
  };

  void _handleButtonPress() {
    // Retrieve the text from the controller
    String inputText = _controller.text;

    // Compare the input text to the list of codes
    if (_codes.contains(inputText)) {
      print('Code matched: $inputText');
      // Navigate to the new page and pass the code
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondPage(exam: exams["$inputText"]),
        ),
      );
    } else {
      print('No match found for: $inputText');
      // You can show an alert or a snackbar here if needed
    }

    // Clear the text field
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, -70), // Move the image up by 70 pixels
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset('assets/images/MOE.png'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Code',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleButtonPress,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
