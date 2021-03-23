import 'package:socialio/constants.dart';
import 'package:socialio/form_authentication.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/home/home_page.dart';
import 'package:socialio/pages/navbar/fake_timeline.dart';
import 'package:flutter/material.dart';
import 'package:socialio/pages/navbar/bottombar.dart';

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
          const RaisedButton(
            onPressed: null,
            child: Text('             Settings             ',
                style: TextStyle(fontSize: 35,)),
          ),
          ElevatedButton(
            
            child: Text('Account Information'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TargetPage()),
              );
            },
          ),
          ElevatedButton(
            child: Text('     Profile Settings     '),
            onPressed: () {
              // go Porfile Setting page
            },
          ),
          ElevatedButton(
            child: Text('       Preferences       '),
            onPressed: () {
              // go perferences page
            },
          ),
          ElevatedButton(
            child: Text('              Help              '),
            
            onPressed: () {
              // show help page
            },
          ),
          ElevatedButton(
            child: Text('         About Us          '),
            onPressed: () {
              // show about page
            },
          ),
          ElevatedButton(
            child: Text('           Logout            '),
            onPressed: () {
              cancelSignOut(context);
            },
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
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Sign Out"),
    onPressed:  () {
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