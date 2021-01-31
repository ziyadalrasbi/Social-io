import 'package:flutter/material.dart';
import 'package:login_page/pages/home/parts/background.dart';
import 'package:login_page/pages/login/login_screen.dart';

import 'package:login_page/pages/signup/sign_up_second.dart';
import 'package:login_page/parts/button.dart';

// the body of the welcome screen
// this has the login/signup buttons
// the buttons were made in the 'button.dart' class

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // aligning everything central
          children: <Widget>[
            
              
              Image.asset(
                'assets/icons/LOGONEW.png',
              ),
            
            // over here we can put pictures or whatever
            MainButton( // login button
              text: "Login",
              textColor: Colors.white,
              color: Colors.indigo[500],
              pressed: () { // when a button is pressed
                Navigator.push( // Navigator.push is just used to return something when a button is pressed
                context, 
                  MaterialPageRoute(
                    builder: (context){
                      return LoginPage(); // in this case, the login page is returned (i.e. navigate to login page)
                    },
                  ),
                );
              },
            ),
            MainButton( // sign up button
              text: "Sign Up",
              

              color: Colors.white,
              textColor: Colors.indigo,
              pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpSecond();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}




