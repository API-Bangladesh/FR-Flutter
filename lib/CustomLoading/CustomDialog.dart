import 'package:flutter/material.dart';

class CustomDialog {
  final BuildContext context;
  late AlertDialog _dialog;

  CustomDialog(this.context);

  void startLoading(String textTitle) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.blueGrey, // Set the desired value color
              ), // You can replace this with your custom loading widget
              const SizedBox(height: 16.0,width: 16.0,),
              Text(textTitle),
            ],
          ),
        );
      },
    );
  }

  void dismiss() {
    Navigator.of(context).pop();
  }
}
