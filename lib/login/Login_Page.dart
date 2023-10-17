import 'dart:convert';

import 'package:face_recognition_ios_and_android/faceDetector/FaceDetectorPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;



class Login_Page extends StatelessWidget {
  @override

  TextEditingController employeeIDController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Container(
            padding: EdgeInsets.all(20.0),
            constraints: BoxConstraints(maxWidth: 400), // Adjust as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: employeeIDController,
                  decoration: InputDecoration(labelText:  'Enter USER ID',
                      border: OutlineInputBorder(),
                     prefixIcon: Icon(Icons.email),
                ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: userPasswordController,
                  decoration: InputDecoration(labelText: 'Enter Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {

                      },
                      child: Text('Forgot Password?'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String eID = employeeIDController.text.trim();
                    String password = userPasswordController.text.trim();

                    if (eID.isEmpty) {
                      showToast("Please Enter Your ID");
                    } else if (password.isEmpty) {
                      showToast("Please Enter Your Password");
                    } else {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FaceDetectorPage(),
                        ),
                      );

                      // Implement your login logic here
                      // You can use the http package for making network requests
                      // Remember to handle errors and show loading indicator
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> loginUser(String e_ID, String pass) async {
    final String loginURL = "https://frapi.apil.online/employee_permission/login";
    final Map<String, String> data = {
      'E_ID': e_ID,
      'password': pass,
    };

    //final customDialog = showLoadingDialog(); // You'll need to implement this function

    try {
      final response = await http.post(
        Uri.parse(loginURL),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );


      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonObject = jsonDecode(response.body);

        if (jsonObject.containsKey('token')) {
          final String token = jsonObject['token'];
          final List<dynamic> dataArray = jsonObject['data'];

          if (dataArray.isNotEmpty) {
            final Map<String, dynamic> dataObject = dataArray[0];
            final String eId = dataObject['Employee_ID'];
            final String name = dataObject['employee_name'];
            showToast("$eId\n$name"); // Implement your showToast function
            print("onResponse token: $token");

            // You can add your shared preferences logic here
            // FR_sharedpreference.Companion.RemoveToken(LoginActivity.this);
            // FR_sharedpreference.Companion.RemoveE_ID(LoginActivity.this);
            // FR_sharedpreference.Companion.setLoginE_ID(LoginActivity.this, e_ID);
            // FR_sharedpreference.Companion.setLoginToken(LoginActivity.this, token);

            if (jsonObject.containsKey('allowed_locations')) {
              final allowedLocationsArray = jsonObject['allowed_locations'];
              final jsonArrayString = jsonEncode(allowedLocationsArray);
              // Implement your shared preferences logic for allowed locations

              // Navigate to the next screen
              // Use Navigator.push or similar for navigation
            }
          } else {
            showToast("Wrong userName or Password"); // Implement your showToast function
          }
        }
      }
    } catch (error) {

      showToast("Error: $error"); // Implement your showToast function
      }


  }

// You will need to create a loading dialog using a package like 'progress_dialog' and implement showToast accordingly.


}