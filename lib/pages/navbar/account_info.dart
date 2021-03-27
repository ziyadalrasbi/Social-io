import 'package:cloud_firestore/cloud_firestore.dart';
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

class AccountInfo extends StatefulWidget {
  @override
  AccountInfoState createState() => AccountInfoState();
}

class AccountInfoState extends State<AccountInfo> {
  final _bottomNavigationColor = Colors.blue;

  int _currentIndex = 4;
  int totallikes = 0;

  @override
  void initState() {
    getUserInfo();
    getTotalLikes();
    super.initState();
  }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    Constants.DarkModeBool = await HelperFunction.getThemeSharedPref();
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.myFollowers = await HelperFunction.getUserFollowersSharedPref();
    Constants.myFollowing = await HelperFunction.getUserFollowingSharedPref();
    setState(() {
      
    });
  }

  getTotalLikes() async {
    FirebaseFirestore.instance
    .collection('uploads')
    .doc(Constants.myName)
    .collection('images').where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        totallikes+= result.data()['upvotes'];
      setState(() {
        
      });
      });
    });
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
                    "Username:",
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
                            Constants.myName,
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
          Container(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Account Type:",
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
                            Constants.accType,
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
          Container(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Total Followers:",
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
                            Constants.myFollowers.toString(),
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
          Container(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Total Following:",
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
                            Constants.myFollowing.toString(),
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
          Container(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Total Likes:",
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
                            totallikes.toString(),
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
        ],
      )),
    );
  }
}

