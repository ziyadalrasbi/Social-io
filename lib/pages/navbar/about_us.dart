import 'package:socialio/constants.dart';
import 'package:socialio/form_authentication.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/darkmode/darkmode.dart';
import 'package:socialio/pages/home/home_page.dart';
import 'package:socialio/pages/lightmode/lightmode.dart';
import 'package:socialio/pages/navbar/fake_timeline.dart';
import 'package:flutter/material.dart';
import 'package:socialio/pages/navbar/parts/bottombar.dart';
import 'package:socialio/pages/navbar/profile_settings.dart';
import 'package:socialio/parts/button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs> {
  final _bottomNavigationColor = Colors.blue;

  int _currentIndex = 4;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    Constants.DarkModeBool = await HelperFunction.getThemeSharedPref();
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    print("getUserInfo Settings");
    print(Constants.DarkModeBool);
  }

  _launchURL() async {
    const url = 'https://socialioapp.web.app/aboutUs.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          width: dimensions.width * 0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Constants.myAppBar.toString()),
              fit: BoxFit.fill,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),

      // 6 navigate botton
      body: Center(
          child: Column(
        children: [
          Container(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "To find out more about us at SocialIO please \nvisit:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: Row(
                children: [
                  Text(
                    "https://socialioapp.web.app/aboutUs.html",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

cancelSignOut(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Sign Out"),
    onPressed: () {
      signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Sign Out"),
    content: Text("Are you sure you want to sign out?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
