import 'package:flutter/material.dart';
import 'package:login_page/pages/login/login_screen.dart';
import 'package:login_page/pages/signup/partsone/background.dart';
import 'package:login_page/pages/signup/sign_up_second.dart';
import 'package:login_page/parts/account_recheck.dart';
import 'package:login_page/parts/button.dart';


// the first sign up page
// this page comes after the welcome screen if a user presses "Sign Up"
// this will ask them if they want to sign up as a viewer or a creator
class Body extends StatelessWidget {
  final Widget child;
  

  const Body({
    Key key, 
    @required this.child
    }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign up"
            ),
            MainButton(
              text: "Creator",
              pressed: () {
                  Navigator.push(
                  context, 
                    MaterialPageRoute(
                      builder: (context){
                        return SignUpSecond();
                      },
                    ),
                  );
                },
            ),
            Text(
              "maybe a bio here about creators",
            ),
            MainButton(
              text: "Viewer",
             pressed: () {
                  Navigator.push(
                  context, 
                    MaterialPageRoute(
                      builder: (context){
                        return SignUpSecond();
                      },
                    ),
                  );
                },
            ),
            Text(
              "another bio about viewers",
            ),
            AccountRecheck( // the AccountRecheck class is used here, because there is an option at the bottom of the page for "Already have an account? Sign up"
              logged: false,
              pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage(); // it would just return to the login page
                    }
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

