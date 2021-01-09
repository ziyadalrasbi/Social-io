import 'package:flutter/material.dart';
import 'package:login_page/constants.dart';
import 'package:login_page/pages/login/parts/background.dart';
import 'package:login_page/pages/signup/sign_up_first.dart';
import 'package:login_page/parts/account_recheck.dart';
import 'package:login_page/parts/button.dart';
import 'package:login_page/parts/input_field_box.dart';
import 'package:login_page/parts/password_field_box.dart';
import 'package:login_page/parts/text_field_box.dart';

// the login page

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    

    Size dimensions = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login (maybe a picture here or just a nice font)"
          ),
          InputField(
            hint: "Username or email address",
            changes: (value) {},
          ),
          PassField(
            changes: (value) {},
          ),
          MainButton(
            text: "Log In",
            pressed: () {},
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











