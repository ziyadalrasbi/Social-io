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
import 'package:socialio/pages/student/quiz.dart';

class Classroom extends StatefulWidget {
  @override
  _ClassroomState createState() => _ClassroomState();
}

class QuizPick {
  String quizName;
  QuizPick({this.quizName});
}

class _ClassroomState extends State<Classroom> {
  bool _isEditingText = false; //for _setClassroomName
  TextEditingController _editingController; //for _setClassroomName
  String classNameText = "Classroom"; //for _setClassroomName

  @override
  void initState() {
    getUserInfo();
    getQuizzes();
    super.initState();
    _editingController = TextEditingController(
        text: classNameText); //Initialise to say "Classroom Name"
  }

  getUserInfo() async {
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    setState(() {});
  }

  @override
  void dispose() {
    //for _setClassroomName
    _editingController.dispose();
    super.dispose();
  }

  Widget _setClassroomName() {
    return Text(
      classNameText,
      style: TextStyle(
        color: Colors.black,
        fontSize: 50.0,
      ),
    );
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchshot;

  getQuizBtn() {
    if (Constants.accType != "Student") {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/pictures/answer4_selected.png'))),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
          ));
    } else {
      return Container();
    }
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
                  Column(children: [getQuizBtn()])
                ],
              ),
            ],
          )),
    ]);
  }

  List<String> listOfQuizzes = [];

  getQuizzes() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('quizzes').get();
    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) => listOfQuizzes.add(data.id));
    setState(() {});
  }

  Widget _quizPicker() {
    print(listOfQuizzes);
    return ListView.builder(
        itemCount: listOfQuizzes.length,
        itemBuilder: (context, index) {
          final item = listOfQuizzes[index];
          return Card(
              color: Colors.black,
              child: Column(
                children: [
                  Card(
                      child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/pictures/answer1_correct.png'))),
                    child: ListTile(
                      tileColor: Colors.transparent,
                      title: Text(listOfQuizzes[index].toString(),
                          style: TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: Image.asset('assets/icons/ICON_Tick.png'),
                        iconSize: 25,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Quiz(listOfQuizzes[index])));
                        },
                      ),
                    ),
                  )),
                ],
              ));
        });
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
          Expanded(child: Container(child: _quizPicker()))
        ]));
  }
}
