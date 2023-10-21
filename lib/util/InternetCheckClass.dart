import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetCheckClass {
  static Future<void> openInternetDialog(
      BuildContext context, {
        bool trueFalse = false,
        Function? onRetry,
      }) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return AlertDialog(
            title: Text('No Internet Connection'),
            content: Text('Please turn on the Internet connection to continue'),
            actions: <Widget>[
              TextButton(
                child: Text('Retry'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onRetry != null) {
                    onRetry();
                  }
                  if (!trueFalse) {
                    openInternetDialog(context, trueFalse: false, onRetry: onRetry);
                  }
                },
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // You can navigate to a specific screen or perform any desired action here.
                },
              ),
            ],
          );
        },
      );
    }
  }

  static Future<bool> isNetworkConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
