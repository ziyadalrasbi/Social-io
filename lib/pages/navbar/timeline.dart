import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:login_page/extra/chatpage/chat_page.dart';


class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
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
  List<String> postUpvotes = ['76,263', '243,503', '54'];

  bool upVoted = false; 
  bool downVoted = false; 

  Widget _getPost() {
    Size size = MediaQuery.of(context).size;
    return new ListView.builder(
        itemCount: userPosts.length,
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
                                  print('Will take to profile of user');
                                },
                                child: CircleAvatar(
                                  backgroundImage: displayPic[userIndex],
                                ))),
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: userPosts[userIndex],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print(
                                        'This will take to profile of that person');
                                  })
                          ]),
                        )
                      ],
                    ),
                    IconButton(
                      icon: Image.asset('assets/pictures/ICON_flag.png'),
                      iconSize: 25,
                      onPressed: () {
                        print('This will function as a report button');
                      },
                    )
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
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 0,
                    bottom: 24,
                  ),
                    // constraints: BoxConstraints(maxHeight: 50),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill, image: userPostImage[userIndex]),
                    )),
                Positioned(
                    top: 25,
                    left: 50,
                    child: Visibility(
                      //Raised button that comes into view when you tap the image, tap again to get rid of it
                      visible: isVisible,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text('User2563'),
                        color: Colors.blueGrey,
                      ),
                    ))
              ]),
              Row(
                // upvote + downvote + comment + send + save icons
                children: <Widget>[
                  Container(
                    color: upVoted ? Colors.blue : Colors.white,
                      margin: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Image.asset('assets/pictures/ICON_upvote.png'),
                        iconSize: 25,
                        onPressed: () {
                          setState(() {
                            upVoted = true; 
                            downVoted = false;                        
                          });
                        },
                      )
                      
                  ),
                  Container(
                      color: downVoted ? Colors.blue : Colors.white,
                      margin: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Image.asset('assets/pictures/ICON_downvote.png'),
                        iconSize: 25,
                        onPressed: () {
                          setState(() {
                            downVoted = true;
                            upVoted = false;                         
                          });
                        },
                        
                      )),
                  Container(
                      margin: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Image.asset('assets/pictures/ICON_comment.png'),
                        iconSize: 25,
                        onPressed: () {
                          print(
                              'This will open a text box to comment on the post');
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
                          print(
                              'This will let a user save the post so that they can easily find it again');
                        },
                      )),
                ],
              ),
              Column(
                //This column contains username, upload description and total upvotes
                children: <Widget>[
                  Container(
                    //The person who posted along with photo description
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text: userPosts[userIndex] + ': ',
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print(
                                      'This will take to profile of that person');
                                }),
                          TextSpan(text: 'This will be a photo description'),
                        ])),
                  ),
                  Container(
                    //The total upvotes of post
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text: postUpvotes[userIndex] + ' upvotes',
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print(
                                      'This will take to upvoters of the photo');
                                }),
                        ])),
                  )
                ],
              ),
              Column(
                //This column contains username and comment of commenters
                children: <Widget>[
                  Container(
                    //First comment
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text:
                                  'HarperEvans1: ', //will be a username from firebase
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print(
                                      'This will take to profile of that person');
                                }),
                          TextSpan(text: 'Nice photo!'),
                        ])),
                  ),
                  Container(
                    //Second comment
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text:
                                  'trevorwilkinson: ', //will be a username from firebase
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print(
                                      'This will take to profile of that person');
                                }),
                          TextSpan(
                              text:
                                  'Panda Panda Panda Panda Panda Panda Panda Panda Panda Panda Panda Panda Panda Panda'),
                        ])),
                  ),
                  Container(
                    //view more comments
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.grey, fontSize: 20.0),
                            children: <TextSpan>[
                          TextSpan(
                              text:
                                  'view more comments', //will take to the comments
                              style: TextStyle(color: Colors.grey),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('This will take to comments');
                                }),
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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
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
        actions: <Widget>[
          FlatButton(
                child:
                  Image.asset(
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
              ),
        ],
      ),
      body: _getPost(),
    );
  }
}
