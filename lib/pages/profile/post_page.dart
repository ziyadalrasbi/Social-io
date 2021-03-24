import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:socialio/pages/navbar/comments.dart';
import 'package:socialio/pages/navbar/report_panel.dart';
import 'package:socialio/pages/navbar/search/user_profile.dart';
import 'package:socialio/parts/input_field_box.dart';

import '../../constants.dart';
import '../../database.dart';
import '../../helpers.dart';

class PostPage extends StatefulWidget {
  final String userName;
  final String imageId;

  PostPage(this.userName, this.imageId);
  
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
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
  List<String> usernames = [];
  List<int> upvotes = [];
  List<String> captions = [];
  List taggedUsers = [];
  List likedposts = [];
  List downvotedposts = [];
  List taggedbuttons = [];
  TextEditingController commentText = TextEditingController();
  Map<String,String> comments = Map<String, String>();
  
  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    upvotes[postCount] = await HelperFunction.getPostUpvotesSharedPref();
    setState(() {});
  }
@override
  void initState() {
    checkImages();
    getLikedPosts();
    setState(() {
          
        });
    super.initState();
    
  }

  void checkImages() async {
    
    FirebaseFirestore.instance
        .collection("uploads").where('username', isEqualTo: widget.userName)
        .get()
        
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        
        FirebaseFirestore.instance
            .collection("uploads")
            
            .doc(result.id)
            .collection("images").where('imageid', isEqualTo: widget.imageId)
            .get()
            .then((querySnapshot) {
              
          querySnapshot.docs.forEach((result) async {
            final ref =
                FirebaseStorage.instance.ref().child(result.data()['imageid']);
            url = await ref.getDownloadURL();
            setState(() {
            images.add(url);
            posts.add(result.data()['imageid']);
            captions.add(result.data()['caption']);
            usernames.add(result.data()['username']);
            upvotes.add(result.data()['upvotes']);
            taggedUsers.add(result.data()['tagged']);
            _getPost();
            });
          });
        });
      });
    });
  }

  getUpvotes(int index) {
    return TextSpan(
      text: upvotes[index].toString() + ' upvotes',
      style: TextStyle(color: Colors.blue),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          print(
              'This will take to upvoters of the photo');
        });
  }
  
  getLikedPosts() async {
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) { 
        setState(() {
        if (result.data()['likedposts'] != null) {   
          likedposts = result.data()['likedposts'];
        }
        if (result.data()['downvotedposts'] != null) {   
          downvotedposts = result.data()['downvotedposts'];
        }
               
        });
      });
    });
  }

  void addLikedPost() async {
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) { 
        FirebaseFirestore.instance
        .collection('users')
        .doc(result.id)
        .update({'likedposts': likedposts});
        setState(() {   
          _getPost();       
        });
      });
    });
  }

   void addComment(int index) async {
    FirebaseFirestore.instance
        .collection('uploads')
        .doc(usernames[index])
        .collection('images')
        .where('imageid', isEqualTo: posts[index])
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        setState(() {
          FirebaseFirestore.instance
              .collection('uploads')
              .doc(usernames[index])
              .collection('images')
              .doc(result.id)
              .collection('comments')
              .add(
                  {'commenter': Constants.myName, 'comment': commentText.text, 'imageid': posts[index], 'time': DateTime.now().millisecondsSinceEpoch});
        });
      });
    });
  }

void incrementUpvotes(int index) async {
    if (!likedposts.contains(posts[index])) {
      if (downvotedposts.contains(posts[index])) {
        downvotedposts.remove(posts[index]);
        addDownvotedPost();
        upvotes[index] = upvotes[index] + 2;
      } else {
        upvotes[index]++;
      }
      likedposts.add(posts[index]);
      addLikedPost();
      upVoted = true;
      downVoted = false;
      FirebaseFirestore.instance
          .collection('uploads')
          .doc(usernames[index])
          .collection('images')
          .where('caption', isEqualTo: captions[index])
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) async {
          FirebaseFirestore.instance
              .collection('uploads')
              .doc(usernames[index])
              .collection('images')
              .doc(result.id)
              .update({
            'upvotes': upvotes[index],
          });
        });
      });
    }
  }

  void decrementUpvotes(int index) async {
    if (!downvotedposts.contains(posts[index])) {
      if (likedposts.contains(posts[index])) {
        likedposts.remove(posts[index]);
        addLikedPost();
        upvotes[index] = upvotes[index] - 2;
      } else {
        upvotes[index]--;
      }
      downvotedposts.add(posts[index]);
      addDownvotedPost();
      downVoted = true;
      upVoted = false;
      FirebaseFirestore.instance
          .collection('uploads')
          .doc(usernames[index])
          .collection('images')
          .where('caption', isEqualTo: captions[index])
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) async {
          FirebaseFirestore.instance
              .collection('uploads')
              .doc(usernames[index])
              .collection('images')
              .doc(result.id)
              .update({
            'upvotes': upvotes[index],
          });
        });
      });
    }
  }

  returnUpvoteColor(int index) {
    if (likedposts != null) {
      if (likedposts.contains(posts[index])) {
        return Colors.blue;
      } else {
        return Colors.white;
      }
    } else {
      return Colors.white;
    }
  }

  returnDownvoteColor(int index) {
    if (downvotedposts != null) {
      if (downvotedposts.contains(posts[index])) {
        return Colors.blue;
      } else {
        return Colors.white;
      }
    } else {
      return Colors.white;
    }
  }

  returnReportButton(int index) {
    if (widget.userName != Constants.myName) {
      return IconButton(
        icon: Image.asset('assets/pictures/ICON_flag.png'),
        iconSize: 25,
        onPressed: () {
          reportUser(index, context);
    
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.edit),
        iconSize: 25,
        onPressed: () {
          editPost(index, context);
    
        },
      );
    }
  }

  void addDownvotedPost() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'downvotedposts': downvotedposts});
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

  reportUser(int index, BuildContext context) {
    String rep1 = "Contains a human";
    String rep2 = "Harmful content";
    String rep3 = "Spam content";
    String rep4 = "Bullying/harassment";
    String rep5 = "Inappropriate caption/comments";
  // set up the buttons
  Widget firstButton = FlatButton(
    child: Text(rep1),
    onPressed:  () {
      createReport(
        index:index,
        reason:rep1
      );
      Navigator.of(context, rootNavigator: true).pop();
      confirmReport(context);
    },
  );
  Widget secondButton = FlatButton(
    child: Text(rep2),
    onPressed:  () {
      createReport(
        index:index,
        reason:rep2
      );
      Navigator.of(context, rootNavigator: true).pop();
      confirmReport(context);
    },
  );
  Widget thirdButton = FlatButton(
    child: Text(rep3),
    onPressed:  () {
      createReport(
        index:index,
        reason:rep3
      );
      Navigator.of(context, rootNavigator: true).pop();
      confirmReport(context);
    },
  );
  Widget fourthButton = FlatButton(
    child: Text(rep4),
    onPressed:  () {
      createReport(
        index:index,
        reason:rep4
      );
      Navigator.of(context, rootNavigator: true).pop();
      confirmReport(context);
    },
  );
  Widget fifthButton = FlatButton(
    child: Text(rep5),
    onPressed:  () {
      createReport(
        index:index,
        reason:rep5
      );
      Navigator.of(context, rootNavigator: true).pop();
      confirmReport(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Send Report"),
    content: Text("What would you like to report this post for?"),
    actions: [
      firstButton,
      secondButton,
      thirdButton,
      fourthButton,
      fifthButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

editPost(int index, BuildContext context) {
    String rep1 = "Edit caption";
    String rep2 = "Delete post";
    String cancel = "Cancel";
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(cancel),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  Widget editButton = FlatButton(
    child: Text(rep1),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget deleteButton = FlatButton(
    child: Text(rep2, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop();
      confirmDelete(index, context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Edit Post"),
    content: Text("Select an option to edit this post."),
    actions: [
      cancelButton,
      editButton,
      deleteButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

confirmDelete(int index, BuildContext context) {
    String rep1 = "Cancel";
    String rep2 = "Confirm";
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(rep1),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget deleteButton = FlatButton(
    child: Text(rep2, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
    onPressed:  () {
      deletePost(index);
      Navigator.of(context, rootNavigator: true).pop();
      
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Post"),
    content: Text("Are you sure you want to delete this post? This action cannot be undone."),
    actions: [
      cancelButton,
      deleteButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void deletePost(int index) async {
  FirebaseFirestore.instance
    .collection('uploads')
    .doc(Constants.myName)
    .collection('images')
    .where('imageid', isEqualTo: posts[index])
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async { 
        setState(() {     
          FirebaseFirestore.instance
          .collection('uploads')
          .doc(Constants.myName)
          .collection('images')
          .doc(result.id)
          .delete();  
          });
      });
    });
  }



confirmReport(BuildContext context) {
  // set up the buttons
  Widget confirmButton = FlatButton(
    child: Text("OK"),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );


  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Report Sent"),
    content: Text("Your report has been sent and will be reviewed in due time."),
    actions: [
      confirmButton,
     
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

commentPopUp(int index, BuildContext context) {
  // set up the buttons
  Widget commentButton = InputField(
    hint: "Add comment",
    control: commentText,
  );

  Widget confirmButton = FlatButton(
    child: Text("Comment"),
    onPressed: (){
      addComment(index);
      Navigator.of(context, rootNavigator: true).pop();
    } 
  );


  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Add Comment"),
    actions: [
      commentButton,
      confirmButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



  createReport({int index, String reason}) {
    String imageId = posts[index];
    String reporter = Constants.myName;
    String poster = usernames[index];
    DatabaseMethods().createReport(imageId, reporter, poster, reason);
  }
   

  returnTaggedUsers(int index) {
    if (taggedUsers[index].toString().substring(1,taggedUsers[index].toString().length-1).length > 1 ) {
    return Visibility(
      //Raised button that comes into view when you tap the image, tap again to get rid of it
      visible: isVisible,
      child: RaisedButton(
        onPressed: () {
          if (taggedUsers[index].toString().substring(1,taggedUsers[index].toString().length-1) != Constants.myName) {
          Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => UserProfile(taggedUsers[index].toString().substring(1,taggedUsers[index].toString().length-1))
                      ),
                    );
          } else {
            print(likedposts);
          }
        },
        child: Text(taggedUsers[index].toString().substring(1,taggedUsers[index].toString().length-1)),
        color: Colors.blueGrey,
      ),
    );
    } else {
      return Container();
    }
  }
  
    Widget _getPost() {
    
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
                                    builder: (context) => UserProfile(usernames[userIndex])
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: displayPic[1],
                                ))),
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: usernames[userIndex],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder: (context) => UserProfile(usernames[userIndex])
                                      ),
                                    );
                                  })
                          ]),
                        )
                      ],
                    ),
                    
                  returnReportButton(userIndex),
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
                Positioned(
                  
                    top: 25,
                    left: 50,
                    child: returnTaggedUsers(userIndex),)
              ]),
              Row(
                mainAxisAlignment: returnAlignment(),
                // upvote + downvote + comment + send + save icons
                children: <Widget>[
                  Container(
                    color: returnUpvoteColor(userIndex),
                      margin: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Image.asset('assets/pictures/ICON_upvote.png'),
                        iconSize: 25,
                        onPressed: () async {
                          setState(() {
                            incrementUpvotes(userIndex);         
                          });
                        },
                      )

                  ),
                  Container(
                      color: returnDownvoteColor(userIndex),
                      margin: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Image.asset('assets/pictures/ICON_downvote.png'),
                        iconSize: 25,
                        onPressed: () {
                          setState(() {
                            decrementUpvotes(userIndex);                        
                          });
                        },

                      )),
                  Container(
                      margin: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Image.asset('assets/pictures/ICON_comment.png'),
                        iconSize: 25,
                        onPressed: () {
                         commentPopUp(userIndex, context);
                        },
                      )),
                  Container(
                      margin: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Image.asset('assets/pictures/ICON-send.png'),
                        iconSize: 25,
                        onPressed: () {
                          print(
                              'This will let a user send the post to another user');
                        },
                      )),
                  Container(
                      margin: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Image.asset('assets/pictures/ICON_save.png'),
                        iconSize: 25,
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => ReportPanel()
                              ),
                            );
                        },
                      )),
                      
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
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text: usernames[userIndex] + ': ',
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder: (context) => UserProfile(usernames[userIndex])
                                      ),
                                    );
                                }),
                          TextSpan(text: captions[userIndex]),
                        ])),
                  ),
                  Container(
                    //The total upvotes of post
                    alignment: returnCommentAlignment(),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          getUpvotes(userIndex),
                        ])),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: returnAlignment(),
                //This column contains username and comment of commenters
                children: <Widget>[
                  Container(
                      //view more comments
                      alignment: returnCommentAlignment(),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: RichText(
                          text: TextSpan(
                              style:
                                  TextStyle(color: Colors.blue[900], fontSize: 20.0),
                              children: <TextSpan>[
                            TextSpan(
                                text:
                                    'view comments', //will take to the comments
                                style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentPage(
                                              posts[userIndex],
                                              usernames[userIndex])),
                                    );
                                  }),
                          ])),
                    ),
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