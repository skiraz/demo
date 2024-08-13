import 'package:flutter/material.dart';
import 'dart:async';

class LockedScreen extends StatefulWidget {
  @override
  _LockedScreenState createState() => _LockedScreenState();
}

class _LockedScreenState extends State<LockedScreen> {
  bool _isLocked = true;

  @override
  void initState() {
    super.initState();
    // Set the timer to unlock the screen after 10 seconds
    Timer(Duration(seconds: 10), () {
      setState(() {
        _isLocked = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              _isLocked ? "Screen is locked" : "Screen is unlocked",
              style: TextStyle(fontSize: 24),
            ),
          ),
          if (_isLocked)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
