import 'dart:convert';
import 'package:face_recognition_ios_and_android/util/InternetCheckClass.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:face_recognition_ios_and_android/shared_preference/FRSharedPreferences.dart';

import '../faceDetector/FaceDetectorPage.dart';

class Login_Page extends StatefulWidget {
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  TextEditingController employeeIDController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  @override
  Future<void> initState() async {
    super.initState();

    bool isConnected =  InternetCheckClass.isNetworkConnected() as bool;
    if (isConnected) {
      checkAndAutoLogin();
    } else {
      InternetCheckClass.openInternetDialog(context);
    }

  }

  void checkAndAutoLogin() async {
    final String? token = await FRSharedPreferences.getLoginToken();
    if (token != null) {
      // Token exists, automatically log in
      navigateToFaceDetectorPage();
    }
  }

  void navigateToFaceDetectorPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FaceDetectorPage(),
      ),
    );
  }

  void loginUser(String e_ID, String pass) async {
    const String loginURL = "https://frapi.apil.online/employee_permission/login";
    final Map<String, String> data = {
      'E_ID': e_ID,
      'password': pass,
    };

    try {
      final response = await http.post(Uri.parse(loginURL),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonObject = jsonDecode(response.body);

        if (jsonObject.containsKey('token')) {
          final String token = jsonObject['token'];

          // Save token in shared preferences
          FRSharedPreferences.setLoginToken(token);

          if (jsonObject.containsKey('allowed_locations')) {
            final allowedLocationsArray = jsonObject['allowed_locations'];

            final jsonArrayString = jsonEncode(allowedLocationsArray);
            FRSharedPreferences.setAllowedLocations(jsonArrayString);

            navigateToFaceDetectorPage();
          } else {
            showToast("allowed_location is  null");
          }
        } else {
          showToast("Wrong userName or Password");
        }
      } else {
        showToast("Wrong userName or Password");
      }
    } catch (error) {
      print("Status Code: $error");
      showToast("Error Catch: $error");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            constraints: BoxConstraints(maxWidth: 400),
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
                  decoration: InputDecoration(
                    labelText: 'Enter USER ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: userPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
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
                        // Implement your forgot password logic
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String eID = employeeIDController.text.trim();
                    String password = userPasswordController.text.trim();

                    if (eID.isEmpty) {
                      showToast("Please Enter Your ID");
                    } else if (password.isEmpty) {
                      showToast("Please Enter Your Password");
                    } else {

                      bool isConnected = await InternetCheckClass.isNetworkConnected();
                      if (isConnected) {
                        loginUser(eID, password);
                      } else {
                      InternetCheckClass.openInternetDialog(context);
                      }
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
}

void main() {
  runApp(MaterialApp(home: Login_Page()));
}
