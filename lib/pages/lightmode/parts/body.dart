import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/darkmode/darkmode.dart';
import 'package:socialio/pages/navbar/parts/bottombar.dart';

//import 'package:permission_handler/permission_handler.dart';
bool faceDetected;
TextEditingController captionController = TextEditingController();
TextEditingController searchController = TextEditingController();
List<String> taggedUsers = [];

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Constants.DarkModeBool = false;
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: LightMode1(),
    );
  }
}

//widget to capture and crop the image
class LightMode1 extends StatefulWidget {
  createState() => LightModeState();
}

class LightModeState extends State<LightMode1> {
  final _bottomNavigationColor = Colors.blue;

  int _currentIndex = 4;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
  }

  updateTheme() {
    FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection("users")
            .doc(result.id)
            .update({"isDark": true});
        HelperFunction.saveThemeSharedPref(Constants.DarkModeBool);
        setState(() {});
      });
    });
  }


  returnAppBar() {
    Size size = MediaQuery.of(context).size;
    if (kIsWeb) {
      return AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
              "assets/icons/LOGONEW.png", 
              height: 50, 
              alignment: Alignment.center,
            ),
          ],
        ),
      );
    } else {
      return AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            width: size.width * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Constants.myAppBar.toString()),
                fit: BoxFit.fill,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    return Scaffold(
      appBar: returnAppBar(),
      // 6 navigate botton
      body: Center(
          child: Column(
        children: [
          Container(
            color: Colors.black,
            width: dimensions.width,
            height: 2,
          ),
          GestureDetector(
            onTap: () {
              updateTheme();
              print("lightmode page");
              print(Constants.DarkModeBool);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DarkMode()),
              );
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Toggle Dark Mode",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black,
            width: dimensions.width,
            height: 2,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomBar()),
              );
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Go Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black,
            width: dimensions.width,
            height: 2,
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
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Sign Out"),
    onPressed: () {},
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
