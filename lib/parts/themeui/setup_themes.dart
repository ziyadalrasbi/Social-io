import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';

List<ThemeData> getThemes() {
  return [
    ThemeData(backgroundColor: Colors.white, accentColor: primaryLightColour, floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.white)),
    ThemeData(backgroundColor: Colors.black, accentColor: primaryDarkColour, floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.black)),
  ];
}