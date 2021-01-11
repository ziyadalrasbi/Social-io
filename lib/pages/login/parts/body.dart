import 'package:flutter/material.dart';
import 'package:login_page/constants.dart';
import 'package:login_page/form_authentication.dart';
import 'package:login_page/pages/login/login_screen.dart';
import 'package:login_page/pages/login/parts/background.dart';
import 'package:login_page/pages/signup/sign_up_first.dart';
import 'package:login_page/parts/account_recheck.dart';
import 'package:login_page/parts/button.dart';
import 'package:login_page/parts/input_field_box.dart';
import 'package:login_page/parts/password_field_box.dart';
import 'package:login_page/parts/text_field_box.dart';
import 'package:provider/provider.dart';

// the login page

class Body extends StatelessWidget {
  final Widget home;
  Body({
    Key key,
    this.home,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    Size dimensions = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login (maybe a picture here or just a nice font)"
          ),
          InputField(
            control: emailController,
            hint: "Username or email address",
            
          ),
          PassField(
            control: passController,
            
          ),
          MainButton(
            text: "Log In",
            pressed: () {
              context.read<AuthService>().logIn(
                email: emailController.text,
                pass: passController.text,
              );
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











