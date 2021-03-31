import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
import 'package:socialio/parts/input_field_box.dart';

class AccountTag extends StatefulWidget {
  @override
  AccountTagState createState() => AccountTagState();
}

class AccountTagState extends State<AccountTag> {
  final _bottomNavigationColor = Colors.blue;

  static final validTag = RegExp("[a-zA-Z]+");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _currentIndex = 4;
  int totallikes = 0;

  TextEditingController tagInfo = TextEditingController();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    Constants.DarkModeBool = await HelperFunction.getThemeSharedPref();
    //if (Constants.profileTag == null) {
    //   Constants.profileTag = await HelperFunction.getProfileTagSharedPref();
    // } else {
    //   Constants.profileTag = "No Current Tag";
    // }

    setState(() {});
  }

  setTag() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'profiletag': "#" + tagInfo.text});
        setState(() {
          HelperFunction.saveProfileTagSharedPref(tagInfo.text);
        });
      });
    });
  }

  tagDialogBox(BuildContext context) {
    // set up the buttons
    Widget form = Form(
        key: _formKey,
        child: Column(
          children: [
            InputField(
              control: tagInfo,
              hint: "Enter tag...",
              validate: (value) {
                if (value.isEmpty) {
                  return "This can't be empty.";
                }
                if (!validTag.hasMatch(value)) {
                  // first check for first name, just simple validation
                  return "Tags must start with a '#' and not contain special characters";
                }
                if (value.length < 4) {
                  return "Tags must be at least 4 characters.";
                }
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setTag();
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ));

    Widget tagText = InputField(
      control: tagInfo,
      hint: "Enter Channel Tag (Starting with #)...",
      validate: (value) {
        if (value.isEmpty) {
          return "This can't be empty.";
        }
        if (!validTag.hasMatch(value)) {
          // first check for first name, just simple validation
          return "Tags must start with a '#' and not contain special characters";
        }
        if (value.length < 4) {
          return "Tags must be at least 4 characters.";
        }
      },
      key: _formKey,
    );
    Widget confirmButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          setTag();
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Report Sent"),
      content: Text("Tags will help your account get found in search"),
      actions: [
        form,
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
      resizeToAvoidBottomInset: false,
      appBar: returnAppBar(),

      // 6 navigate botton
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Container(
              color: Colors.black,
              width: dimensions.width,
              height: 2,
            ),
            Container(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Current Profile Tag:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Text(
                              //Constants.profileTag,
                              "",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        )),
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
                tagDialogBox(context);
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey[700],
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Change Profile Tag",
                      textAlign: TextAlign.center,
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
      ),
    );
  }
}
