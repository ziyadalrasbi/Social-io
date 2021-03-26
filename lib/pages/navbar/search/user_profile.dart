import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/extra/chatpage/parts/conversation_room.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/profile/post_page.dart';
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
  List followerslist = [];
  List myfollowing = [];
  bool followed = false;
  bool listWanted = false;
  List<String> images = [];
  List posts = [];
  String profilepic = "";
  String profilebanner = "";
  String accType = "";
  var url;

  @override
  void initState() {
    getUserInfo();
    getProfilePic();
    getUserFollowers();
    checkUser();
    getMyFollowing();
    printImages();
    displayPics();
    displayPicsList();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    Constants.myFollowing = await HelperFunction.getUserFollowingSharedPref();
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
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
              posts.add(result.data()['imageid']);
              
              setState(() {
                printImages();
              });
          });
        });
      });
    });
  }

  getProfilePic() async {
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: widget.userName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) { 
        profilepic = result.data()['profilepic'].toString();
        profilebanner = result.data()['banner'].toString();
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
        accType = result.data()['accType'];
        followers = result.data()['followers'];  
        following = result.data()['following'];
        followerslist = result.data()['followerslist'];
        setState(() {
        });
      });
    });
  }

  void getMyFollowing() async {
    FirebaseFirestore.instance
    .collection("users")
    .where("username", isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async { 
        myfollowing = result.data()['followinglist'];
        setState(() {
        });
      });
    });
  }

void updateFollowers() async {
  if (!followerslist.contains(Constants.myName)) {
    followerslist.add(Constants.myName);
     followers++;
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: widget.userName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {     
         
          FirebaseFirestore.instance
          .collection('users')
          .doc(result.id)
          .update({'followers': followers, 'followerslist': followerslist});  
          setState(() {
          });
          
      });
    });
  } else {
    print("already following");
  }
  } 

  

  void updateFollowing() async {
    if (!myfollowing.contains(widget.userName)) {
    myfollowing.add(widget.userName); 
     Constants.myFollowing++;
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {      
        FirebaseFirestore.instance
        .collection('users')
        .doc(result.id)
        .update({'following':Constants.myFollowing,'followinglist': myfollowing}); 
        setState(() {
        }); 
        HelperFunction.saveUserFollowingSharedPref(Constants.myFollowing);
      });
    });
    } 
  }

  void decrementFollowers() async {
    if (followerslist.contains(Constants.myName)) {
      followerslist.remove(Constants.myName);
       followers--;
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: widget.userName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {     
         
          FirebaseFirestore.instance
          .collection('users')
          .doc(result.id)
          .update({'followers': followers, 'followerslist': followerslist});  
          setState(() {
          });
          
      });
    });
    }
  }

  void decrementFollowing() async {
    myfollowing.remove(widget.userName);
     Constants.myFollowing--;
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {      
        FirebaseFirestore.instance
        .collection('users')
        .doc(result.id)
        .update({'following':Constants.myFollowing,'followinglist': myfollowing}); 
        setState(() {
        }); 
        HelperFunction.saveUserFollowingSharedPref(Constants.myFollowing);
      });
    });
    
  }

  returnFollowButton() {
    Size size = MediaQuery.of(context).size;
    if (widget.userName != Constants.myName) {
    if (!myfollowing.contains(widget.userName)) {
      return Container(
        color: Colors.indigo[600],
        child: FlatButton(
          height: size.height * 0.01,
          minWidth: 200,
          color: Colors.indigo[600],
          child: Text("Follow"),
          onPressed: () async {
              setState(() {
                updateFollowers();    
                updateFollowing();                 
              });
          },  
          ),
      );
    } else {
      return Container(
        color: Colors.green,
        child: FlatButton(
          height: size.height * 0.001,
          minWidth: 200,
          color: Colors.green,
          child: Text("Unfollow"),
          onPressed: () async {
              setState(() {
                decrementFollowers();    
                decrementFollowing();    
                returnFollowButton();             
              });
          },  
          ),
      );
    }
    } else {
      return Container();
    }
  }


  printImages() {
    return List.generate(images.length, (index) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => PostPage(widget.userName, posts[index])
            ),
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
        centerTitle: true,
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
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: size.height * 0.55,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(profilebanner),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                          height: size.height*0.015,
                        ),
                      GestureDetector(
                          onTap: () { 
                          },
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage:
                                AssetImage(profilepic),
                            backgroundColor: Colors.transparent,
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
                        "SocialIO " + accType,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      
                      Expanded(
                        child: Container(),
                      ),
                      
                      returnFollowButton(),
                      
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
