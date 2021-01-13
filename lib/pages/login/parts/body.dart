import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/pages/login/parts/background.dart';
import 'package:login_page/pages/signup/sign_up_first.dart';
import 'package:login_page/parts/account_recheck.dart';
import 'package:login_page/parts/button.dart';
import 'package:login_page/parts/input_field_box.dart';
import 'package:login_page/parts/password_field_box.dart';


// the login page

class Body extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  Body({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login (maybe a picture here or just a nice font)"
          ),
          InputField(
            control: emailController,
            hint: "Email address",
            
          ),
          PassField(
            control: passController,
            hint: "Password"
            
          ),
          MainButton(
            text: "Log In",
            pressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passController.text
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }
            },
          ),
          AccountRecheck(
            pressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpFirst();
                  }
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}











