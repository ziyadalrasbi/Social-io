import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class HelperFunction {
  static String sharedPrefUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPrefUserNameKey = "USERNAMEKEY";
  static String sharedPrefUserEmailKey = "USEREMAILKEY";
  static String sharedPrefUserTypeKey = "USERTYPEKEY";

  // save data
  static Future<bool> saveLoggedInSharedPref(bool isLogged) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPrefUserLoggedInKey, isLogged);
  }

  static Future<bool> saveUserNameSharedPref(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPref(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserEmailKey, email);
  }

  static Future<bool> saveUserTypeSharedPref(String accType) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserTypeKey, accType);
  }

  // load data
  static Future<bool> getLoggedInSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPrefUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefUserNameKey);
  }

  static Future<String> getUserEmailSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefUserEmailKey);
  }

  static Future<String> getUserTypeSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefUserTypeKey);
  }
}
