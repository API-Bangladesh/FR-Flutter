import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              value: 0.50,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              backgroundColor: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
