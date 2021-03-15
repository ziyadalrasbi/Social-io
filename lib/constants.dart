import 'package:flutter/material.dart';

// constants are things like theme colours and other constants used in the app

// light theme colour
const primaryLightColour = Color(0xFFB0BEC5);

// dark theme colour
const primaryDarkColour = Colors.blueGrey;

class Constants {
  static String myName = "";
  static String accType = "";
  static List<String> files;
  static int myFollowers = 0;
  static int myFollowing = 0;
}

class ThemeChange with ChangeNotifier {
  ThemeData _themeData;

  ThemeChange(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    _themeData = theme;
  }
  
  notifyListeners();
      
  
}