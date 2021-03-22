import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class HelperFunction {
  static String sharedPrefUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPrefUserNameKey = "USERNAMEKEY";
  static String sharedPrefUserEmailKey = "USEREMAILKEY";
  static String sharedPrefUserTypeKey = "USERTYPEKEY";
  static String sharedPrefFollowersKey = "USERFOLLOWERSKEY";
  static String sharedPrefFollowingKey = "USERFOLLOWINGKEY";
  static String sharedPostUpvotesKey = "POSTUPVOTESKEY";
  static String sharedPrefProfilePicKey = "PROFILEPICKEY";

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

  static Future<bool> saveUserFollowersSharedPref(int followers) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(sharedPrefFollowersKey, followers);
  }

  static Future<bool> saveUserFollowingSharedPref(int following) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(sharedPrefFollowingKey, following);
  }

  static Future<bool> savePostUpvotesSharedPref(int upvotes) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(sharedPostUpvotesKey, upvotes);
  }

  static Future<bool> saveProfilePicSharedPref(String profilepic) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefProfilePicKey, profilepic);
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

  static Future<int> getUserFollowersSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(sharedPrefFollowersKey);
  }

  static Future<int> getUserFollowingSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(sharedPrefFollowingKey);
  }

  static Future<int> getPostUpvotesSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(sharedPostUpvotesKey);
  }

  static Future<String> getProfilePicSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefProfilePicKey);
  }
}
