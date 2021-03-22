import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  final String imageId;
  final String userName;

  CommentPage(this.imageId, this.userName);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {

  List comments = [];
  List commenters = [];
@override
  void initState() {
    getComments();
    setState(() {
          
    });
    super.initState();
    
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

  void getComments() async {
    FirebaseFirestore.instance
    .collection('uploads')
    .doc(widget.userName)
    .collection('images')
    .where('imageid', isEqualTo: widget.imageId)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async { 
        FirebaseFirestore.instance
        .collection('uploads')
        .doc(widget.userName)
        .collection('images')
        .doc(result.id)
        .collection('comments')
        .get()
        .then((result) { 
          querySnapshot.docs.forEach((result) async { 
            setState(() {
            comments.add(result.data()['comment']);
            commenters.add(result.data()['commenter']);
            print(comments);
            });
          });
        });
      });
    });
  }
  Widget _getPost() {
    Size size = MediaQuery.of(context).size;
    return new ListView.builder(
        itemCount: comments.length,
        itemBuilder: (BuildContext context, int userIndex) {
          
          return Container(
            child: Column(
            
            children: <Widget>[
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
                                  commenters[userIndex], //will be a username from firebase
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print(
                                      'This will take to profile of that person');
                                }),
                          TextSpan(text: comments[userIndex]),
                        ])),
                  ),
                  Container(
                    //view more comments
                    alignment: returnCommentAlignment(),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.grey, fontSize: 20.0),
                            children: <TextSpan>[
                        ])),
                  )
                ],
              )
            ],
          ));
        });
    
  }



   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
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
      body: _getPost(),
    );
  }
}