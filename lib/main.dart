import 'package:camera/camera.dart';
import 'package:face_recognition_ios_and_android/Internet_Connection/Connection_Checker.dart';
import 'package:flutter/material.dart';
import 'package:face_recognition_ios_and_android/login/Login_Page.dart';

import 'login/LoginPage.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,),
      home:  Login_Page(),
    );

  }

}

