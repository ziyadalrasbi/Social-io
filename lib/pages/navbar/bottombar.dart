// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:socialio/pages/navbar/timeline.dart';
import 'package:socialio/pages/navbar/setting.dart';
import 'package:socialio/pages/navbar/fake_timeline.dart';
import 'package:socialio/pages/navbar/search/user_search.dart';
import 'package:socialio/pages/navbar/fake_profile.dart';
import 'package:socialio/pages/profile/profile_1.dart';
import 'package:socialio/pages/camera/camera.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
  ));
}

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);
  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  int _currentIndex = 0;

  List _pageList = [
    Posts(), //class name of timeline
    UserSearch(), //class name of search
    Profile(), //class name of profile
    Setup_page(), //class name of setting
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraPage()),
          );
        },
        child: Icon(Icons.camera_alt_outlined),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.2,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        // currentIndex: currentIndex,
        currentIndex: this._currentIndex,
        hasInk: true,
        inkColor: Colors.black,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        // onTap: changePage,

        onTap: (int index) {
          // this._currentIndex=index; //won't rerender
          setState(() {
            this._currentIndex = index;
          });
        },

        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Colors.blue,
            icon: Image.asset(
              "assets/icons/ICON_home.png",
              color: Colors.black,
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              "assets/icons/ICON_home.png",
              color: Colors.blue,
              width: 20,
              height: 20,
            ),
            title: Text('Home'),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.blue,
            icon: Image.asset(
              "assets/icons/ICON_search.png",
              color: Colors.black,
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              "assets/icons/ICON_search.png",
              color: Colors.blue,
              width: 20,
              height: 20,
            ),
            title: Text('Search'),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.blue,
            icon: Image.asset(
              "assets/icons/ICON_profile.png",
              color: Colors.black,
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              "assets/icons/ICON_profile.png",
              color: Colors.blue,
              width: 20,
              height: 20,
            ),
            title: Text('Profile'),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.blue,
            icon: Image.asset(
              "assets/icons/ICON_hamburger.png",
              color: Colors.black,
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              "assets/icons/ICON_hamburger.png",
              color: Colors.blue,
              width: 20,
              height: 20,
            ),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
