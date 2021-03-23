import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/extra/chatpage/parts/conversation_room.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/profile/post_page.dart';
import 'package:socialio/pages/profile/reward.dart';

class Profile extends StatefulWidget {
  @override
  _Profile1State createState() => _Profile1State();
}

class _Profile1State extends State<Profile> {
  
  int followers = 0;
  int following = 0;
  int postTime = 0;
  int listCount = 0;
  bool listWanted = false;
  List images = [];
  List posts = [];
  var url;
  @override
  void initState() {
    getUserInfo();
    returnFollowers();
    checkImages();
    printImages();
    displayPics();
    displayPicsList();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    Constants.myFollowing = await HelperFunction.getUserFollowingSharedPref();
    Constants.myProfilePic = await HelperFunction.getProfilePicSharedPref();
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    Constants.myAppBanner = await HelperFunction.getProfileBannerSharedPref();
    Constants.myAppBorder = await HelperFunction.getProfileBorderSharedPref();
    setState(() {});
  }

  void checkImages() async {
    FirebaseFirestore.instance
        .collection("uploads")
        .where('username', isEqualTo: Constants.myName)
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
              printImages();
            });
          });
        });
      });
    });
  }

  void returnFollowers() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      setState(() {
        followers = querySnapshot.docs[0].data()['followers'];
        following = querySnapshot.docs[0].data()['following'];
      });

      setState(() {});
    });
  }

  printImages() {
    
    return List.generate(images.length, (index) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostPage(Constants.myName, posts[index])),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
          flexibleSpace: Container(
            width: size.width*0.5,
            decoration: 
              BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Constants.myAppBar.toString()),
                  fit: BoxFit.fill,
                ),
              ),
          ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: size.height * 0.50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Constants.myAppBanner.toString()),
                              fit: BoxFit.cover,
                            ),
                         ),
                  child: Container(
                    height: size.height * 0.40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Constants.myAppBorder.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: size.height*0.035,
                        ),
                  
                          
                        
                        GestureDetector(
                          onTap: () { 
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Reward();
                                }
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage:
                                AssetImage(Constants.myProfilePic.toString()),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      
                      SizedBox(
                        height: size.height * 0.00925,
                      ),
                      Text(
                        Constants.myName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.00625,
                      ),
                      Text(
                        "SocialIO " + Constants.accType,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        height: size.height * 0.075,
                        color: Colors.black.withOpacity(0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "FOLLOWERS",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    followers.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 110,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "FOLLOWING",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      following.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                Material(
                  elevation: 1,
                  child: Container(
                    height: 56,
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
                            color: listWanted ? Colors.grey : Colors.black,
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
                            color: listWanted ? Colors.black : Colors.grey,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.60 - 56,
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
    );
  }
}
