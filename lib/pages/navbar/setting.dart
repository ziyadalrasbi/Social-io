import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/form_authentication.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/main.dart';
import 'package:socialio/pages/darkmode/darkmode.dart';
import 'package:socialio/pages/home/home_page.dart';
import 'package:socialio/pages/lightmode/lightmode.dart';
import 'package:socialio/pages/login/login_screen.dart';
import 'package:socialio/pages/navbar/about_us.dart';
import 'package:socialio/pages/navbar/account_info.dart';
import 'package:socialio/pages/navbar/fake_timeline.dart';
import 'package:flutter/material.dart';
import 'package:socialio/pages/navbar/parts/bottombar.dart';
import 'package:socialio/pages/navbar/profile_settings.dart';
import 'package:socialio/pages/navbar/saved_posts.dart';
import 'package:socialio/pages/profile/profile_badges.dart';
import 'package:socialio/parts/button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Setup_page extends StatefulWidget {
  @override
  _Setup_pageState createState() => _Setup_pageState();
}


class _Setup_pageState extends State<Setup_page> {
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
  }

  _launchURL() async {
    const url = 'https://www2.macs.hw.ac.uk/~jw147/Social-IO-Website/aboutUs.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL2() async {
    const url = 'https://www2.macs.hw.ac.uk/~jw147/Social-IO-Website/userGuide.html';
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
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Container(
              color: Colors.black,
              width: dimensions.width,
              height: 2,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountInfo()),
                  );
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Account Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_right_rounded),
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
                  MaterialPageRoute(builder: (context) => ProfileSettings()),
                );
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Profile Settings",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_right_rounded),
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
                if (Constants.DarkModeBool == true) {
                  print("Preferences true");
                  print(Constants.DarkModeBool);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DarkMode()),
                  );
                } else {
                  print("Preferences else");
                  print(Constants.DarkModeBool);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LightMode()),
                  );
                }
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Preferences",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_right_rounded),
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
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileBadges()
                  ),
                );
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [

                    Text(
                      "Missions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(

                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_right_rounded),
                    ),
                  ],
                )
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
                  MaterialPageRoute(builder: (context) => SavedPosts()),
                );
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Saved Images",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_right_rounded),
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
                _launchURL2();
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Help",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_right_rounded),
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
                _launchURL();
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "About Us",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_right_rounded),
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
                cancelSignOut(context);
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Sign Out",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_right_rounded),
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

bool resetTheme = false;

cancelSignOut(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;
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
      HelperFunction.saveThemeSharedPref(resetTheme);
      Navigator.of(context, rootNavigator: true).pop();
      auth.signOut().then((res) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()));
      });
      
      
      
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
