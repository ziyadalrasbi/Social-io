import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/pages/student/classroom.dart';
import 'package:socialio/pages/student/score.dart';

class Quiz extends StatefulWidget {
  final String quizName;

  Quiz(this.quizName);
  @override
  _QuizState createState() => _QuizState();
}

class Question {
  int questionNo;
  String actualQuestion;
  String answerOne;
  String answerTwo;
  String answerThree;
  String answerFour;
  bool isOnePickedCorrect;
  bool isTwoPickedCorrect;
  bool isThreePickedCorrect;
  bool isFourPickedCorrect;
  Question(
      {this.questionNo,
      this.actualQuestion,
      this.answerOne,
      this.answerTwo,
      this.answerThree,
      this.answerFour,
      this.isOnePickedCorrect,
      this.isTwoPickedCorrect,
      this.isThreePickedCorrect,
      this.isFourPickedCorrect});
}

class _QuizState extends State<Quiz> {
  int counter = 0;
  @override
  void initState() {
    getQuestions();
    super.initState();
  }

  List listOfQuizzes = [];
  List listOfQuestions2 = [];
  List listOfFirstAnswers = [];
  List listOfSecondtAnswers = [];
  List listOfThirdAnswers = [];
  List listOfFourthAnswers = [];
  List listOfFirstBoolAnswers = [];
  List listOfSecondBoolAnswers = [];
  List listOfThirdBoolAnswers = [];
  List listOfFourthBoolAnswers = [];


  getQuestions() async {
    FirebaseFirestore.instance
        .collection('quizzes')
        .where('quizName', isEqualTo: widget.quizName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizName)
            .collection('questions')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) async {
            listOfQuestions2.add(result.data()['actualQuestion'].toString());
            listOfFirstAnswers.add(result.data()['answerOne'].toString());
            listOfSecondtAnswers.add(result.data()['answerTwo'].toString());
            listOfThirdAnswers.add(result.data()['answerThree'].toString());
            listOfFourthAnswers.add(result.data()['answerFour'].toString());
            listOfFirstBoolAnswers.add(result.data()['isOneCorrect']);
            listOfSecondBoolAnswers.add(result.data()['isTwoCorrect']);
            listOfThirdBoolAnswers.add(result.data()['isThreeCorrect']);
            listOfFourthBoolAnswers.add(result.data()['isFourCorrect']);
            setState(() {});
          });
        });
      });
    });
  }

  List<Question> listOfQuestions = [
    Question(
        questionNo: 1,
        actualQuestion: "What colour is a whale?",
        answerOne: "Blue",
        answerTwo: "Gold",
        answerThree: "Purple",
        answerFour: "Green",
        isOnePickedCorrect: false,
        isTwoPickedCorrect: false,
        isThreePickedCorrect: false,
        isFourPickedCorrect: false),
    Question(
        questionNo: 2,
        actualQuestion: "How do U-shaped valleys form?",
        answerOne: "They are dug by workers for skiing competitions",
        answerTwo:
            "The earths position in space moves slightly everyday causing a valley to form over time",
        answerThree:
            "A big glacier cuts through the soil and rock of the valley and piles up the rocks on either side, when the glacier melts a U-shaped valley is left",
        answerFour:
            "Animals eat away at land causing a valley to form over time",
        isOnePickedCorrect: false,
        isTwoPickedCorrect: false,
        isThreePickedCorrect: false,
        isFourPickedCorrect: false),
    Question(
        questionNo: 3,
        actualQuestion: "What colour is the ocean?",
        answerOne: "Green",
        answerTwo: "Blue",
        answerThree: "Black",
        answerFour: "Orange",
        isOnePickedCorrect: false,
        isTwoPickedCorrect: false,
        isThreePickedCorrect: false,
        isFourPickedCorrect: false),
    Question(
        questionNo: 4,
        actualQuestion:
            "What is the fastest recorded speed reached by an aircraft?",
        answerOne: "1450mph",
        answerTwo: "730mph",
        answerThree: "1000mph",
        answerFour: "2100mph",
        isOnePickedCorrect: false,
        isTwoPickedCorrect: false,
        isThreePickedCorrect: false,
        isFourPickedCorrect: false)
  ];

  List<List> listOfListOfAnswers = [];
  bool selected = false;

  returnUpvoteColour() {
    
  }
  int answerIndex = 0;
  int userScore = 0;
  List<bool> answers = [];
  Widget _answerCard(index) {
      print(listOfFirstAnswers);
      print(listOfSecondtAnswers);
      print(listOfQuestions2);
      return Container(
          child: Column(
        children: [
          Card(
              child: ListTile(
                  tileColor:Colors.grey,
                  onTap: () {
                    
                  },
                  leading: Text("1."),
                  title: Text(listOfFirstAnswers[index].toString()),
                  trailing: IconButton(
                      icon: Image.asset('assets/icons/ICON_Tick.png'),
                      iconSize: 25,
                      onPressed: () {
                        setState(() {});
                      }))),
          Card(
              child: ListTile(
                  tileColor: Colors.grey,
                  onTap: () {},
                  leading: Text("2."),
                  title: Text(listOfSecondtAnswers[index].toString()),
                  trailing: IconButton(
                      icon: Image.asset('assets/icons/ICON_Tick.png'),
                      iconSize: 25,
                      onPressed: () {
                        setState(() {});
                      }))),
          Card(
              child: ListTile(
                  tileColor: Colors.grey,
                  onTap: () {},
                  leading: Text("3."),
                  title: Text(listOfThirdAnswers[index].toString()),
                  trailing: IconButton(
                      icon: Image.asset('assets/icons/ICON_Tick.png'),
                      iconSize: 25,
                      onPressed: () {
                        setState(() {});
                      }))),
          Card(
              child: ListTile(
                  tileColor: Colors.grey,
                  onTap: () {},
                  leading: Text("4."),
                  title: Text(listOfFourthAnswers[index].toString()),
                  trailing: IconButton(
                      icon: Image.asset('assets/icons/ICON_Tick.png'),
                      iconSize: 25,
                      onPressed: () {
                        setState(() {});
                      }))),
        ],
      ));
  }

  

  Widget _questionCards() {
    return ListView.builder(
        itemCount: listOfQuestions2.length,
        itemBuilder: (context, index) {
          final item = listOfQuestions2[index];
          return Card(
              color: Color.fromRGBO(4, 10, 120, 1.0),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                        tileColor: Colors.grey,
                        title: Text(listOfQuestions2[index])),
                  ),
                  Container(child: _answerCard(index))
                ],
              ));
        });
  }

  Widget _sumbitQuizBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(4, 10, 120, 1.0),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        textStyle: TextStyle(fontSize: 30),
      ),
      child: Text('SUBMIT ANSWERS'),
      onPressed: () {
        //SUBMIT QUIZ TO DB AND CHECK IF ANSWERS ARE CORRECT
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Score(),
            ));
      },
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
                image: AssetImage("assets/icons/TOPBAR_v2.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(widget.quizName.toString())),
            Expanded(child: Container(child: _questionCards())),
            Container(alignment: Alignment.center, child: _sumbitQuizBtn())
          ],
        ),
        backgroundColor: Colors.white);
  }
}
