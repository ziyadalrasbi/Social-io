import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/extra/chatpage/parts/conversation_room.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/parts/button.dart';

class UserProfile extends StatefulWidget {
  final String userName;
  
  UserProfile(this.userName);

  @override
  _UserProfile1State createState() => _UserProfile1State();
}

class _UserProfile1State extends State<UserProfile> {

  int imageCount = 0;
  int listCount = 0;
  int followers = 0;
  int following = 0;
  bool followed = false;
  bool listWanted = false;
  List<String> images = [];
  var url;

  @override
  void initState() {
    getUserInfo();
    getUserFollowers();
    updateFollowers();
    checkUser();
    printImages();
    displayPics();
    displayPicsList();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    Constants.myFollowing = await HelperFunction.getUserFollowingSharedPref();
    followers = await HelperFunction.getUserFollowersSharedPref();
    setState(() {});
  }

  void checkUser() async {
    FirebaseFirestore.instance
        .collection("uploads")
        .where('username', isEqualTo: widget.userName)
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
                printImages();
              });
          });
        });
      });
      
    });
  }

  

  void getUserFollowers() async {
    FirebaseFirestore.instance
    .collection("users")
    .where("username", isEqualTo: widget.userName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async { 
            
          
        
        setState(() {
          followers = querySnapshot.docs[0].data()['followers'];  
          following = querySnapshot.docs[0].data()['following'];
                  updateFollowers();
                });
      });
    });
  }

void updateFollowers() async {
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: widget.userName)
    .get()
    .then((querySnapshot) {
      if (followed == true) {
      querySnapshot.docs.forEach((result) async {     

          FirebaseFirestore.instance
          .collection('users')
          .doc(result.id)
          .update({'followers': followers++,});  
          setState(() { 
          });
      HelperFunction.saveUserFollowersSharedPref(followers);     
      });
      }
    });
  } 

  void updateFollowing() async {
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      if (followed == true) {
      querySnapshot.docs.forEach((result) async {      
          FirebaseFirestore.instance
          .collection('users')
          .doc(result.id)
          .update({'following': Constants.myFollowing++,});   
          setState(() {
            
          }); 
          HelperFunction.saveUserFollowingSharedPref(Constants.myFollowing);
      });
      }
    });
  }


  printImages() {
    return List.generate(images.length, (index) {
      return GestureDetector(
        onTap: () {
          print( "hello");
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
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/icons/LOGONEW.png",
              height: 50,
              
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: size.height * 0.40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 36,
                      ),
                      GestureDetector(
                        onTap: checkUser,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage:
                              AssetImage("assets/images/wrestler.png"),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        widget.userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 4,
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
                        color: Colors.blue,
                      child: FlatButton(
                        height: 60,
                        minWidth: 200,
                        color: Colors.blue,
                        child: Text("Follow"),
                        onPressed: () async {
                          setState(() {
                             updateFollowers();                         
                           });
                           setState(() {
                              updateFollowing();                           
                            });
                           
                          setState(() {
                            followed = true;
                                                     
                           });
                           
                        },  
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 64,
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
