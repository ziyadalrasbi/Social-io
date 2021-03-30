import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../database.dart';
import '../../helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

List list = [];

class ProfileBadges extends StatefulWidget {
  @override
  _ProfileBadgesState createState() => _ProfileBadgesState();
}

class _ProfileBadgesState extends State<ProfileBadges> {
  checkUserRewards() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        list.add(result.data()['rewards'].toString());
      });
    });
  }

  @override
  void initState() {
    getUserInfo();
    checkUserRewards();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Badges"),
      ),
      body: Center(
          child: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Container(
                      // child: Image.asset('assets/badges/01.png'),
                      child: list[list.length-1].contains('assets/badges/1.png') ? Image.asset('assets/badges/1.png'): Image.asset('assets/badges/01.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('upload a photo'),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/2.png') ? Image.asset('assets/badges/2.png'): Image.asset('assets/badges/02.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('take a photo for african cow'),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/3.png') ? Image.asset('assets/badges/3.png'): Image.asset('assets/badges/03.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('take a photo for giraffe'),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/4.png') ? Image.asset('assets/badges/4.png'): Image.asset('assets/badges/04.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('take a photo for elephant'),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/5.png') ? Image.asset('assets/badges/5.png'): Image.asset('assets/badges/05.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('take a photo for tiger '),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/6.png') ? Image.asset('assets/badges/6.png'): Image.asset('assets/badges/06.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('leave a comment'),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/7.png') ? Image.asset('assets/badges/7.png'): Image.asset('assets/badges/07.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('give a like'),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/8.png') ? Image.asset('assets/badges/8.png'): Image.asset('assets/badges/08.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('get a comment'),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/9.png') ? Image.asset('assets/badges/9.png'): Image.asset('assets/badges/09.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('get a like'),
                    ),
                    Container(
                      child: list[list.length-1].contains('assets/badges/10.png') ? Image.asset('assets/badges/10.png'): Image.asset('assets/badges/010.png'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('get 10 likes'),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
