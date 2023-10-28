import 'dart:convert';
import 'package:face_recognition_ios_and_android/util/InternetCheckClass.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:face_recognition_ios_and_android/shared_preference/FRSharedPreferences.dart';
import '../CustomLoading/CustomDialog.dart';
import '../Internet_Connection/Connection_Checker.dart';
import 'package:face_recognition_ios_and_android/faceDetector/FaceDetectorPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<LoginPage> {
  Connection_Checker connectionChecker = Connection_Checker();
  TextEditingController employeeIDController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  late CustomDialog customDialog;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    customDialog = CustomDialog(context);
    loadValueRememberData();
    checkAndAutoLogin();
  }

  void loadValueRememberData() async {
    final String? rememberData = await FRSharedPreferences.getRememberData();
    if (rememberData != "") {
      showToast(rememberData!);
      setState(() {
        rememberMe = true;
      });
      employeeIDController.text = rememberData;
    } else {
      setState(() {
        rememberMe = false;
      });
    }
  }

  void checkAndAutoLogin() async {
    bool isConnected = await InternetCheckClass.isNetworkConnected();
    final String? token = await FRSharedPreferences.getLoginToken();
    if (isConnected) {
      if (token != "") {
        checkTokenData();
      }
    }
    else {
      InternetCheckClass.openInternetDialog(context);
    }
  }

  void navigateToFaceDetectorPage() {
    print("Navigating to FaceDetectorPage");
    customDialog.dismiss();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FaceDetectorPage(),
      ),
    );
  }

  void checkTokenData() async {
    // Display a loading dialog
    customDialog.startLoading("Please wait...");
    final String? accessToken = await FRSharedPreferences.getLoginToken();
    const String tokenCheck_URL = "https://frapi.apil.online/employee_permission/check";
    try {
      final response = await http.get(
        Uri.parse(tokenCheck_URL),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonObject = jsonDecode(response.body);
        if (jsonObject.containsKey("Access")) {
          bool access = jsonObject['Access'] ?? false;
          print(access);
          if (access) {
            navigateToFaceDetectorPage();
            print("Navigating to FaceDetectorPage"); // Add this print statement


          }
          else {
            customDialog.dismiss();
            showToast("Login Access Failed");
          }
        }
      } else {
        // Handle error cases here
        if (response.statusCode == 401) {
          // Handle unauthorized error
          showToast("unauthorized");
          customDialog.dismiss();
        }
        // Handle other error cases as needed
        customDialog.dismiss();
      }
    } catch (error) {
      // Handle network errors
      showToast(error.toString());
      customDialog.dismiss();
    }
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: rememberMe ? Colors.green : Colors
                                  .orangeAccent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Checkbox(
                            value: rememberMe ?? false,
                            onChanged: (value) async {
                              setState(() {
                                rememberMe = value!;
                              });
                              if (value!) {
                                String rememberDataFromET = employeeIDController
                                    .text.trim();
                                if (rememberDataFromET.isEmpty) {
                                  showToast("Please Enter your user ID");
                                  setState(() {
                                    rememberMe = false;
                                  });
                                } else {
                                  FRSharedPreferences.setRememberData(
                                      context, rememberDataFromET);
                                  showToast("Value saved");
                                }
                              } else {
                                employeeIDController.text = "";
                                FRSharedPreferences.removeRememberData();
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        const Text('Remember Me'),
                      ],
                    ),
                    SizedBox(width: 20),
                    // Add space between "Remember Me" and "Forgot Password?"
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
                      bool isConnected = await InternetCheckClass
                          .isNetworkConnected();
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

