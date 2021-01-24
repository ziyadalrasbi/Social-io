
import 'package:flutter/material.dart';
import 'package:login_page/extra/aboutus/parts/background.dart';
import 'package:login_page/extra/chatpage/chat_page.dart';
import 'package:login_page/form_authentication.dart';
import 'package:login_page/parts/button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// the login page

class Body extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  Body({
    Key key,
  }) : super(key: key);


  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Social-io is a photo sharing social media platform developed by (stepbro software)."
          ),
          Text(
            "The platform has been developed for creative people to showcase their work and achievements."
          ),
          Text(
            "To find out more about the team, usage guides and our products vist:"
          ),
          InkWell(
            child: new Text(
              "Social-io",
              style: new TextStyle(color: Colors.blue),
            ),
             onTap: () => launch('https://www.google.com')
          ),
          MainButton(
            text: "Sign Out",
            pressed: () async { 
              Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => ChatPage(),
                ));
            },
          ),
        ],
      ),
    );
  }
}