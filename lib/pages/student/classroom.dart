import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/extra/chatpage/parts/conversation_room.dart';
import 'package:socialio/pages/student/make_quiz.dart';
import 'package:socialio/pages/student/view_quizzes.dart';
import 'package:socialio/parts/input_field_box.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/parts/input_field_box.dart';
import 'package:socialio/pages/student/make_quiz.dart';

class Classroom extends StatefulWidget {
  @override
  _ClassroomState createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom> {
  bool _isEditingText = false; //for _setClassroomName
  TextEditingController _editingController; //for _setClassroomName
  String classNameText = "Classroom Name"; //for _setClassroomName

  @override
  void initState() {
    //for _setClassroomName
    super.initState();
    _editingController = TextEditingController(
        text: classNameText); //Initialise to say "Classroom Name"
  }

  @override
  void dispose() {
    //for _setClassroomName
    _editingController.dispose();
    super.dispose();
  }

  Widget _setClassroomName() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              classNameText = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        //makes the text respond to a tap
        onTap: () {
          setState(() {
            _isEditingText = true; //goes into editing mode
          });
        },
        child: Text(
          classNameText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ));
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchshot;

  // @override
  // void initState() {
  //   super.initState();
  // }

  Widget listSearch() {
    return searchshot != null
        ? ListView.builder(
            itemCount: searchshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchshot.docs[index].data()["username"],
                userEmail: searchshot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  initSearch() {
    databaseMethods.getUsername(searchEditingController.text).then((val) {
      setState(() {
        searchshot = val;
        searchEditingController.clear();
      });
    });
  }

  Widget searchTile({String userName, String userEmail}) {
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
              students.add(userName);
              setState(() {});
            },
            child: Container(
              color: primaryDarkColour,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("INVITE"),
            ),
          ),
        ],
      ),
    );
  }

  createChat({String userName}) {
    if (userName != Constants.myName) {
      String roomId = getRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> roomMap = {
        "users": users,
        "roomId": roomId,
      };
      DatabaseMethods().createChat(roomId, roomMap);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConversationRoom(roomId)),
      );
    } else {
      print("Can't chat with yourself!");
    }
  }

  Widget _searchBar() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: InputField(
                    color: Colors.blueGrey[200],
                    control: searchEditingController,
                    hint: "Search for students",
                    changes: (val) {},
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    initSearch();
                  },
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
        ],
      ),
    );
  }

  List<String> students = [
    'Bobby',
    'Clarence',
    'Sassy',
    'Somebody',
    'Sean Kingston',
    'Pure mad jimmy',
    'Jason Jenova',
    'Philip',
    'Brucie',
    'Epa',
    'Okja',
    'George',
    'Sady',
    'Jackson',
    'Elizabeth',
    'Andrew',
  ];

  Widget _listStudents() {
    return new ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, int index) {
        return Container(
            padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
            decoration: new BoxDecoration(color: Colors.white),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.blue,
                elevation: 10,
                child: new ListTile(
                  leading: Image.asset("assets/pictures/ICON_Student.png"),
                  title: Text(students[index]),
                )));
      },
    );
  }

  Widget _getClassroom() {
    return Column(children: [
      Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center, child: _setClassroomName()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          textStyle: TextStyle(fontSize: 30),
                        ),
                        child: Text('MY QUIZZES'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Viewquizzes(),
                              ));
                        },
                      ),
                    ],
                  ),
                  Column(children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        textStyle: TextStyle(fontSize: 30),
                      ),
                      child: Text('NEW QUIZ'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Quizmaker(),
                            ));
                      },
                    )
                  ])
                ],
              ),
              Container(
                child: _searchBar(),
              ),
            ],
          )),
    ]);
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
                image: AssetImage("assets/icons/TOPBAR_v2.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(children: [
          _getClassroom(),
          Expanded(
              child: Container(
            child: _listStudents(),
          ))
        ]));
  }
}

getRoomId(String x, String y) {
  if (x.substring(0, 1).codeUnitAt(0) > y.substring(0, 1).codeUnitAt(0)) {
    return "$y\_$x";
  } else {
    return "$x\_$y";
  }
}
