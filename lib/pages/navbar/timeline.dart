import 'dart:async';
import 'dart:io';

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
import 'package:socialio/pages/student/make_quiz.dart';
import 'package:socialio/parts/input_field_box.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../database.dart';
import '../../helpers.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  bool isVisible = true;

  //Assets used will be replaced with json

  var url;
  
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
  List profilepics = [];
  List comments = [];
  List commenters = [];
  List savedposts = [];
  List myfollowing = [];
  StreamController upvoteStream;
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
    getMyFollowing();
    getSavedPosts();
    checkImages();
    getLikedPosts();
    super.initState();
  }

  checkImages() async {
    FirebaseFirestore.instance
        .collection("uploads")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection("uploads")
            .doc(result.id)
            .collection("images").orderBy('time', descending: true)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) async {
            if (myfollowing.contains(result.data()['username']) || result.data()['username'] == Constants.myName) {
            final ref =
                FirebaseStorage.instance.ref().child(result.data()['imageid']);
            url = await ref.getDownloadURL();
            setState(() {
              images.add(url);
               if (result.data()['imageid'] != null) {
              posts.add(result.data()['imageid']);
               }
               if (result.data()['caption'] != null) {
              captions.add(result.data()['caption']);
               }
               if (result.data()['username'] != null) {
              usernames.add(result.data()['username']);
               }
               if (result.data()['upvotes'] != null) {
              upvotes.add(result.data()['upvotes']);
               }
              if (result.data()['tagged'] != null) {
              taggedUsers.add(result.data()['tagged']);
              }
              if (result.data()['profilepic'] != null) {
                profilepics.add(result.data()['profilepic']);
              }
              _getPost();
            });
            }
          });
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

  getUpvotes(int index) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('uploads')
          .doc(usernames[index])
          .collection('images')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                  children: <TextSpan>[
                TextSpan(
                    text: upvotes[index].toString() + ' upvotes',
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('This will take to upvoters of the photo');
                      }),
              ]));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
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

  void addComment(int index) async {
    dynamic currentTime = DateFormat.jm().format(DateTime.now());
    FirebaseFirestore.instance
        .collection('uploads')
        .doc(usernames[index])
        .collection('images')
        .where('imageid', isEqualTo: posts[index])
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        setState(() {
          commentMissionComplete();
          getCommentMissionComplete(index);
          FirebaseFirestore.instance
              .collection('uploads')
              .doc(usernames[index])
              .collection('images')
              .doc(result.id)
              .collection('comments')
              .add({
            'commenter': Constants.myName,
            'comment': commentText.text,
            'imageid': posts[index],
            'time': DateTime.now().millisecondsSinceEpoch
          });
          commentText.clear();
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
      likeMissionComplete();
      getLikeMissionComplete(index);
      upVoted = true;
      downVoted = false;
      FirebaseFirestore.instance
          .collection('uploads')
          .doc(usernames[index])
          .collection('images')
          .where('imageid', isEqualTo: posts[index])
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
    } else {
      unIncrementUpvotes(index);
    }
  }

  void unIncrementUpvotes(int index) async {
    if (likedposts.contains(posts[index]) && !downvotedposts.contains(posts[index])) {
      upvotes[index]--;
      likedposts.remove(posts[index]);
      addLikedPost();
      upVoted = false;
       FirebaseFirestore.instance
          .collection('uploads')
          .doc(usernames[index])
          .collection('images')
          .where('imageid', isEqualTo: posts[index])
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
          .where('imageid', isEqualTo: posts[index])
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
    } else {
      unDecrementUpvotes(index);
    }
  }

  void unDecrementUpvotes(int index) async {
    if (downvotedposts.contains(posts[index]) && !likedposts.contains(posts[index])) {
      upvotes[index]++;
      downvotedposts.remove(posts[index]);
      addDownvotedPost();
      downVoted = false;
       FirebaseFirestore.instance
          .collection('uploads')
          .doc(usernames[index])
          .collection('images')
          .where('imageid', isEqualTo: posts[index])
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
  commentMissionComplete() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/6.png'])});
      });
    });
  }

  likeMissionComplete() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/7.png'])});
      });
    });
  }

  getLikeMissionComplete(int index) async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: usernames[index])
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/8.png'])});
      });
    });
  }

  getCommentMissionComplete(int index) async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: usernames[index])
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/9.png'])});
      });
    });
  }

  returnUpvoteColor(int index) {
    if (likedposts != null) {
      if (likedposts.contains(posts[index])) {
        return Colors.blue;
      } else {
        return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  returnSaveColor(int index) {
    if (savedposts != null) {
      if (savedposts.contains(posts[index])) {
        return Colors.blue;
      } else {
        return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  returnDownvoteColor(int index) {
    if (downvotedposts != null) {
      if (downvotedposts.contains(posts[index])) {
        return Colors.blue;
      } else {
        return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  getSavedPosts() async {
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async { 
        setState(() {
          if (result.data()['savedposts'] != null) {
            savedposts = result.data()['savedposts'];
          }
        });
      });
    });
  }
  addSavedPost(int index) async {
    if (!savedposts.contains(posts[index])) {
      savedposts.add(posts[index]);
    FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async { 
        FirebaseFirestore.instance
        .collection('users')
        .doc(result.id)
        .update({'savedposts': savedposts});
        setState(() {
          _getPost();
        });
      });
    });
    } else {
      removeSavedPost(index);
    }
  }

  removeSavedPost(int index) async {
    if (savedposts.contains(posts[index])) {
      savedposts.remove(posts[index]);
      FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async { 
        FirebaseFirestore.instance
        .collection('users')
        .doc(result.id)
        .update({'savedposts': savedposts});
        setState(() {
          _getPost();
        });
      });
    });
    }
  }

  returnWidth() {
    Size size = MediaQuery.of(context).size;
    if (kIsWeb) {
      return 700;
    } else {
      return size.width;
    }
  }

  returnHeight() {
    Size size = MediaQuery.of(context).size;
    if (kIsWeb) {
      return 700;
    } else if (Platform.isIOS || Platform.isAndroid) {
      return size.height * 0.5;
    } else {
      return size.height * 0.5;
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

  
  returnReportButton(int index) {
    if (Constants.accType == "Manager") {
      return editPost(index, context);
    } else {
      return reportUser(index, context);
    }
  }

  returnReportIcon(int index) {
    if (Constants.accType == "Manager") {
      return Icon(Icons.delete_forever_outlined, color: Colors.red);
    } else {
      return Image.asset('assets/pictures/ICON_flag.png');
    }
  }

  returnReportIconDark(int index) {
    if (Constants.accType == "Manager") {
      return Icon(Icons.delete_forever_outlined, color: Colors.red);
    } else {
      return Image.asset('assets/pictures/DARKICON_flag.png');
    }
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

  Widget deleteButton = FlatButton(
    child: Text(rep2, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop();
      confirmDelete(index, context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Post"),
    content: Text("Select an option to delete this post."),
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
          .delete();  
          });
      });
    });
  }
  
  reportUser(int index, BuildContext context) {
    String rep1 = "Contains a human";
    String rep2 = "Harmful content";
    String rep3 = "Spam content";
    String rep4 = "Bullying/harassment";
    String rep5 = "Inappropriate caption/comments";
    String cancel = "Cancel";
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        cancel,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget firstButton = FlatButton(
      child: Text(
        rep1,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      onPressed: () {
        createReport(index: index, reason: rep1);
        Navigator.of(context, rootNavigator: true).pop();
        confirmReport(context);
      },
    );
    Widget secondButton = FlatButton(
      child: Text(
        rep2,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      onPressed: () {
        createReport(index: index, reason: rep2);
        Navigator.of(context, rootNavigator: true).pop();
        confirmReport(context);
      },
    );
    Widget thirdButton = FlatButton(
      child: Text(
        rep3,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      onPressed: () {
        createReport(index: index, reason: rep3);
        Navigator.of(context, rootNavigator: true).pop();
        confirmReport(context);
      },
    );
    Widget fourthButton = FlatButton(
      child: Text(
        rep4,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      onPressed: () {
        createReport(index: index, reason: rep4);
        Navigator.of(context, rootNavigator: true).pop();
        confirmReport(context);
      },
    );
    Widget fifthButton = FlatButton(
      child: Text(
        rep5,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      onPressed: () {
        createReport(index: index, reason: rep5);
        Navigator.of(context, rootNavigator: true).pop();
        confirmReport(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      
      title: Text("Send Report"),
      content: Text("What would you like to report this post for?"),
      actions: [
        cancelButton,
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

  confirmReport(BuildContext context) {
    // set up the buttons
    Widget confirmButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Report Sent"),
      content:
          Text("Your report has been sent and will be reviewed in due time."),
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
      hint: "Comment...",
      control: commentText,
    );

    Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          commentText.clear();
          Navigator.of(context, rootNavigator: true).pop();
    });

    Widget confirmButton = FlatButton(
        child: Text("Comment"),
        onPressed: () {
          addComment(index);
          
          Navigator.of(context, rootNavigator: true).pop();
    });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      scrollable: true,
      title: Text("Add Comment"),
      actions: [
        commentButton,
        cancelButton,
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

  shareImage(int index, BuildContext context) {
    // set up the buttons
    Widget rowButton = Row(
        children: [
          Expanded(
            child: InputField(
              color: Colors.blueGrey[200],
              control: searchController,
              hint: "Search...",
              changes: (val) {
              },
            ),
          ),
        ],
        
      );

    Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
    });
    
    Widget confirmButton = FlatButton(
      onPressed: () {
        initSearch();
        createChat(index: index);
        sendMessage(index);
         Navigator.of(context, rootNavigator: true).pop();
      }, 
      child: Text("Share"),
      );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Share Image"),
      content:
          Text("Search for a user to share to:"),
      actions: [
        rowButton,
        confirmButton,
        cancelButton,
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


  initSearch() {
    databaseMethods.getUsername(searchController.text)
    .then((val){
      setState(() {
        searchshot = val;
      });
    });
  }

  QuerySnapshot searchshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchController = TextEditingController();

  sendMessage(int index) {
    String roomId = getRoomId(searchController.text, Constants.myName);
    if(searchController.text.isNotEmpty) {
    Map<String,dynamic> textMap = {
      "message": posts[index],
      "sentBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
    };
    databaseMethods.addConvoText(roomId, textMap);
    searchController.clear();
    }
  }

  createChat({int index}) {
    if (searchController.text != Constants.myName) {
    String roomId = getRoomId(searchController.text, Constants.myName);
    List<String> users = [searchController.text, Constants.myName];
    Map<String, dynamic> roomMap = {
      "users": users,
      "roomId": roomId,
    };
    DatabaseMethods().createChat(roomId, roomMap);
    } else {
      print("Can't chat with yourself!");
    }
  }

  getRoomId(String x, String y) {
    if (x.substring(0,1).codeUnitAt(0) > y.substring(0,1).codeUnitAt(0)) {
      return "$y\_$x";
    } else {
      return "$x\_$y";
    }
  }

  returnMessageIcon(int index) {
    if (Constants.accType == "Student") {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(right: 8),
        child: IconButton(
          icon: Image.asset('assets/pictures/ICON_comment.png'),
          iconSize: 25,
          onPressed: () {
            commentPopUp(index, context);
          },
        )
      );
    }
  }

  returnShareIcon(int index) {
    if (Constants.accType == "Student") {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(right: 8),
        child: IconButton(
          icon: Image.asset('assets/pictures/ICON-send.png'),
          iconSize: 25,
          onPressed: () {
            shareImage(index, context);
          }
        )
      );
    }
  }

  returnMessageIconDark(int index) {
    if (Constants.accType == "Student") {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(right: 8),
        child: IconButton(
          icon: Image.asset('assets/pictures/DARKICON_comment.png'),
          iconSize: 25,
          onPressed: () {
            commentPopUp(index, context);
          },
        )
      );
    }
  }

  returnShareIconDark(int index) {
    if (Constants.accType == "Student") {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(right: 8),
        child: IconButton(
          icon: Image.asset('assets/pictures/DARKICON_send.png'),
          iconSize: 25,
          onPressed: () {
            shareImage(index, context);
          }
        )
      );
    }
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
              taggedUsers.add(searchController.text);
              print(taggedUsers);
              searchController.clear();
            },
            child: Container(
              color: primaryDarkColour,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Tag"),
            ),
          ),
        ],
      ),
    );
  }

  createReport({int index, String reason}) {
    String imageId = posts[index];
    String reporter = Constants.myName;
    String poster = usernames[index];
    DatabaseMethods().createReport(imageId, reporter, poster, reason);
  }

  returnTaggedUsers(int index) {
    if (taggedUsers[index].toString().length > 1) {
      for (String post in posts) {
        if (taggedUsers[index]
                .toString()
                .substring(1, taggedUsers[index].toString().length)
                .length >
            1) {
          return Visibility(
            //Raised button that comes into view when you tap the image, tap again to get rid of it
            visible: isVisible,
            child: Container(
              child: Text(
                taggedUsers[index]
                    .toString()
                    .substring(1, taggedUsers[index].toString().length),
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 18.0,
                ),
              ),
              color: Colors.transparent,
            ),
          );
        } else {
          return Container();
        }
      }
    } else {
      return Container();
    }
  }


  Widget _getPost() {
    Size size = MediaQuery.of(context).size;
    if (url != null) {
      return new ListView.builder(
          itemCount: images.length,
          itemBuilder: (BuildContext context, int userIndex) {
            return Container(
                child: Column(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
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
                                          builder: (context) => UserProfile(
                                              usernames[userIndex])),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        profilepics[userIndex].toString()),
                                  ))),
                          RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: usernames[userIndex],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UserProfile(
                                                usernames[userIndex])),
                                      );
                                    })
                            ]),
                          )
                        ],
                      ),
                      returnTaggedUsers(userIndex),
                      IconButton(
                        icon: returnReportIcon(userIndex),
                        iconSize: 25,
                        onPressed: () {
                          returnReportButton(userIndex);
                        },
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
                      height: returnHeight(),
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
                            fit: BoxFit.fill,
                            image: NetworkImage(images[userIndex])),
                      )),
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
                          onPressed: () {
                            incrementUpvotes(userIndex);

                            setState(() {
                              getUpvotes(userIndex);
                            });
                          },
                        )),
                    Container(
                        color: returnDownvoteColor(userIndex),
                        margin: EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon:
                              Image.asset('assets/pictures/ICON_downvote.png'),
                          iconSize: 25,
                          onPressed: () {
                            setState(() {
                              decrementUpvotes(userIndex);
                            });
                          },
                        )),
                    returnMessageIcon(userIndex),
                    returnShareIcon(userIndex),
                    Container(
                      color: returnSaveColor(userIndex),
                        margin: EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Image.asset('assets/pictures/ICON_save.png'),
                          iconSize: 25,
                          onPressed: () {
                            setState(() {
                              addSavedPost(userIndex);
                            });
                            
                          },
                        )),
                  ],
                ),
                Column(
                  mainAxisAlignment: returnAlignment(),
                  //This column contains username, upload description and total upvotes
                  children: <Widget>[
                    Container(
                      //The total upvotes of post
                      alignment: returnCommentAlignment(),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: getUpvotes(userIndex),
                    ),
                    Container(
                      //The person who posted along with photo description
                      alignment: returnCommentAlignment(),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                              children: <TextSpan>[
                            TextSpan(
                                text: usernames[userIndex] + ': ',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserProfile(
                                              usernames[userIndex])),
                                    );
                                  }),
                            TextSpan(text: captions[userIndex]),
                          ])),
                    ),
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
                              style: TextStyle(
                                  color: Colors.blue[900], fontSize: 20.0),
                              children: <TextSpan>[
                            TextSpan(
                                text:
                                    'view comments', //will take to the comments
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold),
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
                    Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 15,
                    ),
                  ],
                )
              ],
            ));
          });
    }
  }

  Widget _getPostDark() {
    Size size = MediaQuery.of(context).size;
    if (url != null) {
      return new ListView.builder(
          itemCount: images.length,
          itemBuilder: (BuildContext context, int userIndex) {
            return Container(
                child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
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
                                          builder: (context) => UserProfile(
                                              usernames[userIndex])),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        profilepics[userIndex].toString()),
                                  ))),
                          RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: usernames[userIndex],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UserProfile(
                                                usernames[userIndex])),
                                      );
                                    })
                            ]),
                          )
                        ],
                      ),
                      returnTaggedUsers(userIndex),
                      IconButton(
                        icon: returnReportIconDark(userIndex),
                        iconSize: 25,
                        onPressed: () {
                         returnReportButton(userIndex);
                        },
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
                      height: returnHeight(),
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
                            fit: BoxFit.fill,
                            image: NetworkImage(images[userIndex])),
                      )),
                 
                ]),
                Row(
                  mainAxisAlignment: returnAlignment(),
                  // upvote + downvote + comment + send + save icons
                  children: <Widget>[
                    Container(
                        color: returnUpvoteColor(userIndex),
                        margin: EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Image.asset('assets/icons/DARKICON_upvote.png'),
                          iconSize: 25,
                          onPressed: () {
                            incrementUpvotes(userIndex);

                            setState(() {
                              getUpvotes(userIndex);
                            });
                          },
                        )),
                    Container(
                        color: returnDownvoteColor(userIndex),
                        margin: EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon:
                              Image.asset('assets/icons/DARKICON_downvote.png'),
                          iconSize: 25,
                          onPressed: () {
                            setState(() {
                              decrementUpvotes(userIndex);
                            });
                          },
                        )),
                    returnMessageIconDark(userIndex),
                    returnShareIconDark(userIndex),
                    Container(
                      color: returnSaveColor(userIndex),
                        margin: EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Image.asset('assets/icons/DARKICON_save.png'),
                          iconSize: 25,
                          onPressed: () {
                            setState(() {
                              addSavedPost(userIndex);
                            });
                            
                          },
                        )),
                  ],
                ),
                Column(
                  mainAxisAlignment: returnAlignment(),
                  //This column contains username, upload description and total upvotes
                  children: <Widget>[
                    Container(
                      //The total upvotes of post
                      alignment: returnCommentAlignment(),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: getUpvotes(userIndex),
                    ),
                    Container(
                      //The person who posted along with photo description
                      alignment: returnCommentAlignment(),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              children: <TextSpan>[
                            TextSpan(
                                text: usernames[userIndex] + ': ',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserProfile(
                                              usernames[userIndex])),
                                    );
                                  }),
                            TextSpan(text: captions[userIndex]),
                          ])),
                    ),
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
                              style: TextStyle(
                                  color: Colors.blue[900], fontSize: 20.0),
                              children: <TextSpan>[
                            TextSpan(
                                text:
                                    'view comments', //will take to the comments
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold),
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
                    Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 15,
                    ),
                  ],
                )
              ],
            ));
          });
    }
  }


  returnMessaging() {
    if (Constants.accType != "Student") {
      return FlatButton(
              child: Image.asset(
                'assets/icons/ICON_inbox.png',
                width: 45,
                height: 45,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(),
                  ),
                );
              },
            );
    } else {
      return Container();
    }
  }

  returnCreateQuiz() {
    if (Constants.accType == "Creator") {
      return FlatButton(
              child: Image.asset(
                'assets/icons/ICON_chalkboard.png',
                width: 45,
                height: 45,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Quizmaker(),
                  ),
                );
              },
            );
    } else {
      return Container();
    }
  }

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (Constants.DarkModeBool == false) {
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
          actions: <Widget>[
            Container(
              width: size.width,
              child: Row(                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                        returnCreateQuiz(),
                        returnMessaging(),
                ],
              ),
            )
          ],
        ),
        body: _getPost(),
      );
    } else {
      return Scaffold(
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
          actions: <Widget>[
            Container(
              width: size.width,
              child: Row(                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  returnCreateQuiz(),
                  returnMessaging(),
                ],
              ),
            )
          ],
        ),
        body: _getPostDark(),
      );
    }
  }
}
