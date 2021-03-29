// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:socialio/extra/chatpage/chat_page.dart';
import 'package:socialio/pages/camera/camera.dart';
import 'package:socialio/pages/navbar/saved_posts.dart';
import 'package:socialio/pages/navbar/search/explore.dart';
import 'package:socialio/pages/navbar/timeline.dart';
import 'package:socialio/pages/navbar/setting.dart';
import 'package:socialio/pages/navbar/fake_timeline.dart';
import 'package:socialio/pages/navbar/search/user_search.dart';
import 'package:socialio/pages/navbar/fake_profile.dart';
import 'package:socialio/pages/profile/profile_1.dart';
import 'package:socialio/pages/navbar/bottom.dart';
import 'package:socialio/pages/student/classroom.dart';

import '../../../constants.dart';
import '../../../helpers.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
  ));
}

class BodyB extends StatelessWidget {
  getTheme() async {
    Constants.DarkModeBool = await HelperFunction.getThemeSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
    if (Constants.DarkModeBool == true) {
      return MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: BottomBar(),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        home: BottomBar(),
      );
    }
  }
}

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);
  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  int _currentIndex = 0;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    setState(() {});
  }

  List _pageList = [
    Posts(), //class name of timeline
    Explore(), //class name of search
    Profile(), //class name of profile
    (Constants.accType == "Student") ? Classroom() : SavedPosts(),
    Setup_page(), //class name of setting
  ];

  returnStudentButton() {
    if (Constants.accType == "Student") {
      return BubbleBottomBarItem(
        backgroundColor: Colors.blue,
        icon: Image.asset(
          "assets/icons/StudentICON.png",
          color: Colors.black,
          width: 20,
          height: 20,
        ),
        activeIcon: Image.asset(
          "assets/icons/StudentICON.png",
          color: Colors.blue,
          width: 20,
          height: 20,
        ),
        title: Text('Classroom'),
      );
    } else {
      return BubbleBottomBarItem(
        backgroundColor: Colors.blue,
        icon: Image.asset(
          "assets/icons/ICON_inbox.png",
          width: 20,
          height: 20,
        ),
        activeIcon: Image.asset(
          "assets/icons/ICON_inbox.png",
          width: 20,
          height: 20,
        ),
        title: Text('Messages'),
      );
    }
  }

  returnStudentButtonDARK() {
    if (Constants.accType == "Student") {
      return BubbleBottomBarItem(
        backgroundColor: Colors.blue,
        icon: Image.asset(
          "assets/icons/StudentICON.png",
          color: Colors.white,
          width: 20,
          height: 20,
        ),
        activeIcon: Image.asset(
          "assets/icons/StudentICON.png",
          color: Colors.blue,
          width: 20,
          height: 20,
        ),
        title: Text('Classroom'),
      );
    } else {
      return BubbleBottomBarItem(
        backgroundColor: Colors.blue,
        icon: Image.asset(
          "assets/icons/ICON_inbox.png",
          width: 20,
          height: 20,
        ),
        activeIcon: Image.asset(
          "assets/icons/ICON_inbox.png",
          width: 20,
          height: 20,
        ),
        title: Text('Messages'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Constants.DarkModeBool == false) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
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
            returnStudentButton(),
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
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
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
          backgroundColor: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          // currentIndex: currentIndex,
          currentIndex: this._currentIndex,
          hasInk: true,
          inkColor: Colors.white,
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
                color: Colors.white,
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
                color: Colors.white,
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
                color: Colors.white,
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
            returnStudentButtonDARK(),
            BubbleBottomBarItem(
              backgroundColor: Colors.blue,
              icon: Image.asset(
                "assets/icons/ICON_hamburger.png",
                color: Colors.white,
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
}
