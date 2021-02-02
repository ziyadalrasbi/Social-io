import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';


// this is a small section for when someone clicks "dont have an account" or "alread have an account"
// this would redirect them to either the login page or signup page

class AccountRecheck extends StatelessWidget {
  final bool logged; // a simple boolean that will check either state
  final Function pressed; // a function that detects if the option was pressed
  const AccountRecheck({
    Key key, 
    this.logged = true, 
    this.pressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row( // a row if items
      mainAxisAlignment: MainAxisAlignment.center, // aligning central
      children: <Widget>[ // creating a widget
        Text(
          logged ? "Don't have an account? " : "Already have an account? ", // this is where the comparison is done, instead of having 2 seperate classes it can be done in one class
          style: TextStyle(color: Colors.black, fontSize: 15), // making the initial text have a lighter colour
        ),
        GestureDetector( // gesture detector just checks gestures
          onTap: pressed, // here it checks if the "sign up" or "log in" buttons were pressed
          child: Text(
            logged ? "Sign up" : "Log in", // again the boolean check which will take the user to either page
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15), // making the other text bold and darker to make it easier to click
          ),
        ),
      ],
    );
  }
}