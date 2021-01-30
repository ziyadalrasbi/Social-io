import 'package:login_page/form_authentication.dart';
import 'package:login_page/pages/home/home_page.dart';
import 'package:login_page/pages/navbar/fake_timeline.dart';
import 'package:flutter/material.dart';
import 'package:login_page/pages/navbar/bottombar.dart';

class Setup_page extends StatefulWidget {
  @override
  _Setup_pageState createState() => _Setup_pageState();
}

class _Setup_pageState extends State<Setup_page> {
  final _bottomNavigationColor = Colors.blue;

  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            child: Text('            About Us             '),
            onPressed: () {
              // show about page
            },
          ),
          ElevatedButton(
            child: Text('           Logout            '),
            onPressed: () {
              signOut();
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}
