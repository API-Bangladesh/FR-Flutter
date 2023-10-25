import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FRSharedPreferences {
  static Future<void> setLoginToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_key', token);
  }

  static Future<String?> getLoginToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token_key');
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_key');
  }

  static Future<void> setLoginBoolean(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Login', value);
  }

  static Future<bool> getLoginSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('Login') ?? false;
  }

  static Future<void> setAllowedLocations(String? allowedLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('allowedlocation', allowedLocation ?? '');
  }

  static Future<void> removeAllowedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('allowedlocation');
  }

  static Future<String?> getAllowedLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('allowedlocation') ?? '';
  }

  static Future<void> saveBitmap(String base64Image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('image', base64Image);
  }

  static Future<String?> getSavedBitmap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('image');
  }

  static Future<void> removeSavedBitmap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('image');
  }

  static Future<void> saveImageResponse(bool imageCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('uploadImage', imageCheck);
  }

  static Future<bool> getImageResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('uploadImage') ?? false;
  }

  static Future<void> removeImageResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uploadImage');
  }

  static Future<void> removeLoginUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
  }

  static Future<void> setRememberData(BuildContext context, String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("userID", id);
  }


  static Future<String?> getRememberData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userID") ?? '';
  }

  static Future<void> removeRememberData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userID");

  }

  static Future<void> setCheckRememberData(bool checkData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', checkData);
  }

  static Future<bool> getCheckRememberData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe') ?? false;
  }

  static Future<void> saveLocationData(
      String? id, String? latitude, String? longitude, String? locationName, String? user, String? eId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ID', id ?? '');
    await prefs.setString('latitude', latitude ?? '');
    await prefs.setString('longitude', longitude ?? '');
    await prefs.setString('location_name', locationName ?? '');
    await prefs.setString('User', user ?? '');
    await prefs.setString('E_ID', eId ?? '');
  }

  static Future<Map<String, String?>> getLocationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'ID': prefs.getString('ID') ?? '',
      'latitude': prefs.getString('latitude') ?? '',
      'longitude': prefs.getString('longitude') ?? '',
      'location_name': prefs.getString('location_name') ?? '',
      'User': prefs.getString('User') ?? '',
      'E_ID': prefs.getString('E_ID') ?? '',
    };
  }
}
