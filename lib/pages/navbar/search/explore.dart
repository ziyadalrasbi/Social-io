import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';

import 'package:socialio/extra/chatpage/chat_page.dart';

import 'package:socialio/pages/navbar/comments.dart';

import 'package:socialio/pages/navbar/report_panel.dart';

import 'package:socialio/pages/navbar/search/user_profile.dart';

import 'package:socialio/pages/profile/post_page.dart';

import 'package:socialio/parts/input_field_box.dart';

import 'package:intl/intl.dart';

import '../../../constants.dart';

import '../../../database.dart';

import '../../../helpers.dart';

class Explore extends StatefulWidget {
  @override
  ExploreState createState() => ExploreState();
}

class ExploreState extends State<Explore> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchEditingController = new TextEditingController();

  QuerySnapshot searchshot;

  bool isVisible = true;

  //Assets used will be replaced with json

  List<ExactAssetImage> displayPic = [
    ExactAssetImage('assets/pictures/giraffepic.jpg'),
    ExactAssetImage('assets/pictures/boat.jpg'),
    ExactAssetImage('assets/pictures/city.jpg')
  ];

  List<String> userPosts = ['Daniel', 'Hollie', 'Giraffe'];

  List<ExactAssetImage> userPostImage = [
    ExactAssetImage('assets/pictures/panda.jpg'),
    ExactAssetImage('assets/pictures/edinburgh.jpg'),
    ExactAssetImage('assets/pictures/water.jpeg')
  ];

  List<String> test;

  var url;

  int postCount = 0;

  List<String> postUpvotes = ['76,263', '243,503', '54'];

  String posterName;

  bool upVoted = false;

  bool downVoted = false;

  int listCount = 0;

  bool listWanted = false;

  List<String> posts = [];

  List<String> images = [];

  List<String> usernames = [];

  List<int> upvotes = [];

  List<String> captions = [];

  List taggedUsers = [];

  List likedposts = [];

  List downvotedposts = [];

  List taggedbuttons = [];

  List profilepics = [];

  List comments = [];

  List commenters = [];

  List username = [];

  TextEditingController commentText = TextEditingController();

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();

    checkImages();

    checkImagesTagged();


    displayPics();

    displayPicsList();

    super.initState();
  }

  void checkImages() async {
    FirebaseFirestore.instance
        .collection("uploads")
        .where('username', isNotEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection("uploads")
            .doc(result.id)
            .collection("images")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) async {
            final ref =
                FirebaseStorage.instance.ref().child(result.data()['imageid']);

            url = await ref.getDownloadURL();

            images.add(url);

            setState(() {
              posts.add(result.data()['imageid']);

              username.add(result.data()['username']);

              
            });
          });
        });
      });
    });
  }

  checkImagesTagged() async {
    FirebaseFirestore.instance
        .collection("uploads")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection("uploads")
            .doc(result.id)
            .collection("images")
            .where('tagged', isEqualTo: searchEditingController.text)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) async {
            final ref =
                FirebaseStorage.instance.ref().child(result.data()['imageid']);

            url = await ref.getDownloadURL();

            images.add(url);

            setState(() {
              posts.add(result.data()['imageid']);

              username.add(result.data()['username']);

              printImages();
            });
          });
        });
      });
    });
  }

  removePostsArray() {
    posts = [];
  }

  printImages() {
    return List.generate(images.length, (index) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostPage(posts[index])),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Image.network(
            images[index],
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  displayPics() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: BouncingScrollPhysics(),
      children: printImages(),
    );
  }

  displayPicsList() {
    return GridView.count(
      crossAxisCount: 1,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: BouncingScrollPhysics(),
      children: printImages(),
    );
  }

  returnWidth() {
    Size size = MediaQuery.of(context).size;

    if (kIsWeb) {
      return 700;
    } else {
      return size.width;
    }
  }

  returnAlignment() {
    if (kIsWeb) {
      return MainAxisAlignment.center;
    } else {
      return MainAxisAlignment.start;
    }
  }

  initSearch() {
    if ('${searchEditingController.text[0]}' == "#") {
      removePostsArray();

      images = [];

      databaseMethods.getTag(searchEditingController.text).then((val) {
        databaseMethods.getProfileTag(searchEditingController.text).then((val) {
          setState(() {
            searchshot = val;

            searchEditingController.clear();
          });
        });
      });

      checkImagesTagged();

      printImages();
    } else {
      databaseMethods.getUsername(searchEditingController.text).then((val) {
        setState(() {
          searchshot = val;

          searchEditingController.clear();
        });
      });
    }
  }

  createChat({String userName}) {
    if (userName != Constants.myName) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfile(userName)),
      );
    } else {
      print("Can't chat with yourself!");
    }
  }

  Widget listSearch() {
    return searchshot != null
        ? ListView.builder(
            itemCount: searchshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchshot.docs[index].data()["username"],
                userEmail: searchshot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  Widget listSearchTag() {
    return searchshot != null
        ? ListView.builder(
            itemCount: searchshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTileTag(
                profileTag: searchshot.docs[index].data()["profiletag"],
                userName: searchshot.docs[index].data()["username"],
              );
            })
        : Container();
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChat(
                userName: userName,
              );
            },
            child: Container(
              color: primaryDarkColour,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("View"),
            ),
          ),
        ],
      ),
    );
  }

  Widget SearchTileTag({String profileTag, String userName}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: primaryDarkColour,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("View"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
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
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: InputField(
                        color: Colors.blueGrey[200],
                        control: searchEditingController,
                        hint: "Search for users or tags",
                        changes: (val) {},
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        initSearch();
                      },
                      backgroundColor: Colors.lightBlue,
                      child: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/icons/ICON_search.png")),
                    ),
                  ],
                ),
              ),
              listSearch(),
              listSearchTag(),
              SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          elevation: 1,
                          child: Container(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    listCount++;

                                    setState(() {
                                      listWanted = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.grid_view,
                                    color:
                                        listWanted ? Colors.grey : Colors.black,
                                    size: 28,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      listWanted = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.view_list,
                                    color:
                                        listWanted ? Colors.black : Colors.grey,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.70 - 68,
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 0,
                            bottom: 24,
                          ),
                          child: listWanted ? displayPicsList() : displayPics(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
