import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:socialio/extra/chatpage/chat_page.dart';
import 'package:socialio/pages/navbar/search/user_profile.dart';
import 'package:socialio/parts/button.dart';

import '../../constants.dart';
import '../../database.dart';
import '../../helpers.dart';


class ReportPanel extends StatefulWidget {
  @override
  _ReportPanelState createState() => _ReportPanelState();
}

class _ReportPanelState extends State<ReportPanel> {
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

  List<String> posts = [];
  List<String> images = [];
  List<String> posters = [];
  List<String> reasons = [];
  List<String> reporters = [];
  List likedposts = [];

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    setState(() {});
  }
@override
  void initState() {
    checkImages();
    setState(() {    
    });
    super.initState();
    
  }

  void checkImages() async {
    FirebaseFirestore.instance
        .collection("reports")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async{
        final ref =
                FirebaseStorage.instance.ref().child(result.data()['imageid']);
            url = await ref.getDownloadURL();
            setState(() {
            images.add(url);
            posts.add(result.data()['imageid']);
            posters.add(result.data()['poster']);
            reasons.add(result.data()['reason']);
            reporters.add(result.data()['reporter']);
            _getPost();
            });
      });
    });
  }

void deletePost(int index) async {
  FirebaseFirestore.instance
    .collection('uploads')
    .doc(posters[index])
    .collection('images')
    .where('imageid', isEqualTo: posts[index])
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async { 
        setState(() {     
          FirebaseFirestore.instance
          .collection('uploads')
          .doc(posters[index])
          .collection('images')
          .doc(result.id)
          .delete();  
          });
         
      });
    });
  
  }

  void deleteReport(int index) async {
    FirebaseFirestore.instance
    .collection('reports')
    .where('imageid', isEqualTo: posts[index]).where('reason', isEqualTo: reasons[index])
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) { 
        FirebaseFirestore.instance
        .collection('reports')
        .doc(result.id)
        .delete();
        setState(() {
          _getPost();
        });
      });
    });
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

  returnCommentAlignment() {
    if (kIsWeb) {
      return Alignment.center;
    } else {
      return Alignment.topLeft;
    }
  }

  

  
  
    _getPost() {
    
    Size size = MediaQuery.of(context).size;
    if (url!= null) {
    return new ListView.builder(
        itemCount: images.length,
        itemBuilder: (BuildContext context, int userIndex) {
          
          return Container(
            child: Column(
            
            children: <Widget>[
              Container(
                 
                //Includes dp + username + report flag
                margin: EdgeInsets.all(10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 8),
                            child: GestureDetector(
                                onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => UserProfile(posters[userIndex])
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: displayPic[1],
                                ))),
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: posters[userIndex],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder: (context) => UserProfile(posters[userIndex])
                                      ),
                                    );
                                  })
                          ]),
                        )
                      ],
                    ),
                    
                  ],
                ),
              ),
              Stack(children: <Widget>[
                Container(
                  
                    //the post picture
                    child: GestureDetector(
                      //This is to handle the tagged users raised button
                      onTap: () {
                        if (isVisible == false)
                          setState(() {
                            isVisible = true;
                          });
                        else
                          setState(() {
                            isVisible = false;
                          });
                          
                      },
                    ),
                    height: size.height * 0.5,
                    width: returnWidth(),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 0,
                    bottom: 24,
                  ),
                    // constraints: BoxConstraints(maxHeight: 50),
                   
                    decoration: BoxDecoration(
                      image: DecorationImage(
                         

                          fit: BoxFit.fill, image: NetworkImage(images[userIndex])),
                    )
                    
                    ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // upvote + downvote + comment + send + save icons
                children: <Widget>[
                  SizedBox(width: 5,),
                  FlatButton(
                    color: Colors.indigo[500],
                    child: Text("Remove Post", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      deletePost(userIndex);
                      deleteReport(userIndex);
                    },
                    minWidth: size.width*0.45,
                  ),
                  
                  FlatButton(
                    minWidth: size.width*0.45,
                    child: Text("Remove Report", style: TextStyle(color: Colors.white),),
                    color: Colors.indigo[300],
                    onPressed: () {
                      deleteReport(userIndex);
                    },
                  ),
                  SizedBox(width: 5,),
                ],
              ),
              Column(
                mainAxisAlignment: returnAlignment(),
                //This column contains username, upload description and total upvotes
                children: <Widget>[
                  Container(
                    
                    //The person who posted along with photo description
                    alignment: returnCommentAlignment(),
                    margin: EdgeInsets.only(left: 10, right: 10),
                   
                  ),
                  
                ],
              ),
              Column(
                mainAxisAlignment: returnAlignment(),
                //This column contains username and comment of commenters
                children: <Widget>[
                  Container(
                    //First comment
                    alignment: returnCommentAlignment(),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text:
                                  'User who posted the picture: ',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                          TextSpan(text: posters[userIndex]),
                        ])),
                  ),
                  Container(
                    //Second comment
                    alignment: returnCommentAlignment(),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text:
                                  'User who reported the picture: ', //will be a username from firebase
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                          TextSpan(
                              text: reporters[userIndex]),
                        ])),
                  ),
                  Container(
                    //view more comments
                    alignment: returnCommentAlignment(),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text:
                                  'Report reason: ', //will take to the comments
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                              text: reasons[userIndex]),
                        ])),
                  )
                ],
              )
            ],
          ));
        });
    }
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
      body: _getPost(),
    );
  }
}