import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/pages/student/classroom.dart';

class Quizmaker extends StatefulWidget {
  @override
  _QuizMakerState createState() => _QuizMakerState();
}

class QuestionCard {
  int questionNo;
  String actualQuestion;
  String answerOne;
  String answerTwo;
  String answerThree;
  String answerFour;
  bool isBeingEdited;
  bool isOneBeingEdited;
  bool isTwoBeingEdited;
  bool isThreeBeingEdited;
  bool isFourBeingEdited;
  TextEditingController _editControl;
  TextEditingController _editControlOne;
  TextEditingController _editControlTwo;
  TextEditingController _editControlThree;
  TextEditingController _editControlFour;
  bool isOneCorrect;
  bool isTwoCorrect;
  bool isThreeCorrect;
  bool isFourCorrect;
  QuestionCard(
      {this.questionNo,
      this.actualQuestion,
      this.answerOne,
      this.answerTwo,
      this.answerThree,
      this.answerFour,
      this.isBeingEdited,
      this.isOneBeingEdited,
      this.isTwoBeingEdited,
      this.isThreeBeingEdited,
      this.isFourBeingEdited,
      this.isOneCorrect,
      this.isTwoCorrect,
      this.isThreeCorrect,
      this.isFourCorrect});
}

class ButtonQuestionNo {
  int buttonNo;
  ButtonQuestionNo({this.buttonNo});
}

class _QuizMakerState extends State<Quizmaker> {
  bool _isEditingText = false;
  TextEditingController _editingController;
  String classNameText = "Quiz Name"; //for _setQuizName
  Color color;
  String questionText = "Please insert question";
  String answerText = "please insert answer";

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: classNameText);
    color = Colors.white;
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Widget _setQuizName() {
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

  Widget _saveQuizBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*0.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/pictures/answer4_selected.png'))),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            textStyle: TextStyle(fontSize: 18),
          ),
          child: Text('SAVE QUIZ'),
          onPressed: () {
            for (int i = 0; i < listOfQuestions.length; i++) {
              makeQuiz(i);
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Classroom(),
                ));
          },
        ));
  }

  Widget _newQuestionBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*0.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/pictures/answer4_green.png'))),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            textStyle: TextStyle(fontSize: 18),
          ),
          child: Text('+ QUESTION'),
          onPressed: () {
            addQuestionToList();
          },
        ));
  }

  void addQuestionToList() {
    setState(() {
      listOfQuestions.insert(
          listOfQuestions.length,
          QuestionCard(
              questionNo: listOfQuestions.length + 1,
              actualQuestion: "new question",
              answerOne: "answer 1",
              answerTwo: "answer 2",
              answerThree: "answer 3",
              answerFour: "answer 4",
              isBeingEdited: false,
              isOneBeingEdited: false,
              isTwoBeingEdited: false,
              isThreeBeingEdited: false,
              isFourBeingEdited: false,
              isOneCorrect: false,
              isTwoCorrect: false,
              isThreeCorrect: false,
              isFourCorrect: false));
    });
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  void makeQuiz(int index) {
    Map<String, dynamic> quizNumberMap = {"quizName": classNameText};
    databaseMethods.uploadQuiz(classNameText, quizNumberMap);

    Map<String, dynamic> quizMap = {
      "questionNo": listOfQuestions[index].questionNo,
      "actualQuestion": listOfQuestions[index].actualQuestion,
      "answerOne": listOfQuestions[index].answerOne,
      "answerTwo": listOfQuestions[index].answerTwo,
      "answerThree": listOfQuestions[index].answerThree,
      "answerFour": listOfQuestions[index].answerFour,
      "isOneCorrect": listOfQuestions[index].isOneCorrect,
      "isTwoCorrect": listOfQuestions[index].isTwoCorrect,
      "isThreeCorrect": listOfQuestions[index].isThreeCorrect,
      "isFourCorrect": listOfQuestions[index].isFourCorrect,
    };
    databaseMethods.createQuiz(classNameText, quizMap);
  }

  List<QuestionCard> listOfQuestions = [
    QuestionCard(
        questionNo: 1,
        actualQuestion: "please insert a question",
        answerOne: "please insert an answer",
        answerTwo: "please insert an answer",
        answerThree: "please insert and answer",
        answerFour: "please insert an answer",
        isBeingEdited: false,
        isOneBeingEdited: false,
        isTwoBeingEdited: false,
        isThreeBeingEdited: false,
        isFourBeingEdited: false,
        isOneCorrect: false,
        isTwoCorrect: false,
        isThreeCorrect: false,
        isFourCorrect: false)
  ];

  Widget _setQuestionText(index) {
    if (listOfQuestions[index].isBeingEdited)
      return Center(
        child: TextField(
          style: TextStyle(color: Colors.white),
          onSubmitted: (newValue) {
            setState(() {
              listOfQuestions[index].actualQuestion = newValue;
              listOfQuestions[index].isBeingEdited = false;
            });
          },
          autofocus: true,
          controller: listOfQuestions[index]._editControl,
        ),
      );
    return InkWell(
        //makes the text respond to a tap
        onTap: () {
          setState(() {
            listOfQuestions[index].isBeingEdited =
                true; //goes into editing mode
            listOfQuestions[index]._editControl = TextEditingController(
                text: listOfQuestions[index].actualQuestion);
          });
        },
        child: Text(
          listOfQuestions[index].actualQuestion,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ));
  }

  Widget _deleteQuestionBtn(index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        padding: EdgeInsets.all(10),
        textStyle: TextStyle(fontSize: 30),
      ),
      child: Text('X'),
      onPressed: () {
        setState(() {
          listOfQuestions.removeAt(index);
        });
      },
    );
  }

  Widget _setAnswerOneText(index) {
    if (listOfQuestions[index].isOneBeingEdited)
      return Center(
        child: TextField(
          style: TextStyle(color: Colors.white),
          onSubmitted: (newValue) {
            setState(() {
              listOfQuestions[index].answerOne = newValue;
              listOfQuestions[index].isOneBeingEdited = false;
            });
          },
          autofocus: true,
          controller: listOfQuestions[index]._editControlOne,
        ),
      );
    return InkWell(
        //makes the text respond to a tap
        onTap: () {
          setState(() {
            listOfQuestions[index].isOneBeingEdited =
                true; //goes into editing mode
            listOfQuestions[index]._editControlOne =
                TextEditingController(text: listOfQuestions[index].answerOne);
          });
        },
        child: Text(
          listOfQuestions[index].answerOne,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ));
  }

  Widget _setAnswerTwoText(index) {
    if (listOfQuestions[index].isTwoBeingEdited)
      return Center(
        child: TextField(
          style: TextStyle(color: Colors.white),
          onSubmitted: (newValue) {
            setState(() {
              listOfQuestions[index].answerTwo = newValue;
              listOfQuestions[index].isTwoBeingEdited = false;
            });
          },
          autofocus: true,
          controller: listOfQuestions[index]._editControlTwo,
        ),
      );
    return InkWell(
        //makes the text respond to a tap
        onTap: () {
          setState(() {
            listOfQuestions[index].isTwoBeingEdited =
                true; //goes into editing mode
            listOfQuestions[index]._editControlTwo =
                TextEditingController(text: listOfQuestions[index].answerTwo);
          });
        },
        child: Text(
          listOfQuestions[index].answerTwo,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ));
  }

  Widget _setAnswerThreeText(index) {
    if (listOfQuestions[index].isThreeBeingEdited)
      return Center(
        child: TextField(
          style: TextStyle(color: Colors.white),
          onSubmitted: (newValue) {
            setState(() {
              listOfQuestions[index].answerThree = newValue;
              listOfQuestions[index].isThreeBeingEdited = false;
            });
          },
          autofocus: true,
          controller: listOfQuestions[index]._editControlThree,
        ),
      );
    return InkWell(
        //makes the text respond to a tap
        onTap: () {
          setState(() {
            listOfQuestions[index].isThreeBeingEdited =
                true; //goes into editing mode
            listOfQuestions[index]._editControlThree =
                TextEditingController(text: listOfQuestions[index].answerThree);
          });
        },
        child: Text(
          listOfQuestions[index].answerThree,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ));
  }

  Widget _setAnswerFourText(index) {
    if (listOfQuestions[index].isFourBeingEdited)
      return Center(
        child: TextField(
          style: TextStyle(color: Colors.white),
          onSubmitted: (newValue) {
            setState(() {
              listOfQuestions[index].answerFour = newValue;
              listOfQuestions[index].isFourBeingEdited = false;
            });
          },
          autofocus: true,
          controller: listOfQuestions[index]._editControlFour,
        ),
      );
    return InkWell(
        //makes the text respond to a tap
        onTap: () {
          setState(() {
            listOfQuestions[index].isFourBeingEdited =
                true; //goes into editing mode
            listOfQuestions[index]._editControlFour =
                TextEditingController(text: listOfQuestions[index].answerFour);
          });
        },
        child: Text(
          listOfQuestions[index].answerFour,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ));
  }

  Widget _answerCard(index) {
    return Container(
        child: Column(
      children: [
        Card(
            child: Container(
                decoration: listOfQuestions[index].isOneCorrect
                    ? BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/pictures/answer1_correct.png')))
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/pictures/answer1.png'))),
                child: ListTile(
                    onTap: () {},
                    leading: Text("1.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        )),
                    title: _setAnswerOneText(index),
                    trailing: IconButton(
                        icon: Image.asset('assets/icons/ICON_Tick.png'),
                        iconSize: 25,
                        onPressed: () {
                          setState(() {
                            if (listOfQuestions[index].isOneCorrect) {
                              listOfQuestions[index].isOneCorrect = false;
                            } else {
                              listOfQuestions[index].isOneCorrect = true;
                            }
                          });
                        })))),
        Card(
            child: Container(
                decoration: listOfQuestions[index].isTwoCorrect
                    ? BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/pictures/answer2_correct.png')))
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/pictures/answer2.png'))),
                child: ListTile(
                    onTap: () {},
                    leading: Text("2.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        )),
                    title: _setAnswerTwoText(index),
                    trailing: IconButton(
                        icon: Image.asset('assets/icons/ICON_Tick.png'),
                        iconSize: 25,
                        onPressed: () {
                          setState(() {
                            if (listOfQuestions[index].isTwoCorrect) {
                              listOfQuestions[index].isTwoCorrect = false;
                            } else {
                              listOfQuestions[index].isTwoCorrect = true;
                            }
                          });
                        })))),
        Card(
            child: Container(
                decoration: listOfQuestions[index].isThreeCorrect
                    ? BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/pictures/answer3_green.png')))
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/pictures/answer3.png'))),
                child: ListTile(
                    onTap: () {},
                    leading: Text("3.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        )),
                    title: _setAnswerThreeText(index),
                    trailing: IconButton(
                        icon: Image.asset('assets/icons/ICON_Tick.png'),
                        iconSize: 25,
                        onPressed: () {
                          setState(() {
                            if (listOfQuestions[index].isThreeCorrect) {
                              listOfQuestions[index].isThreeCorrect = false;
                            } else {
                              listOfQuestions[index].isThreeCorrect = true;
                            }
                          });
                        })))),
        Card(
            child: Container(
                decoration: listOfQuestions[index].isFourCorrect
                    ? BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/pictures/answer4_green.png')))
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/pictures/answer4.png'))),
                child: ListTile(
                    onTap: () {},
                    leading: Text("4.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        )),
                    title: _setAnswerFourText(index),
                    trailing: IconButton(
                        icon: Image.asset('assets/icons/ICON_Tick.png'),
                        iconSize: 25,
                        onPressed: () {
                          setState(() {
                            if (listOfQuestions[index].isFourCorrect) {
                              listOfQuestions[index].isFourCorrect = false;
                            } else {
                              listOfQuestions[index].isFourCorrect = true;
                            }
                          });
                        }))))
      ],
    ));
  }

  Widget _questionCards() {
    return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: listOfQuestions.length,
        itemBuilder: (context, index) {
          final item = listOfQuestions[index];
          return Dismissible(
              key: ObjectKey(item),
              onDismissed: (direction) {
                setState(() {
                  listOfQuestions.removeAt(index);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/pictures/wood.jpeg'))),
                child: Card(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Card(
                            child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/pictures/question.png'))),
                          child: ListTile(
                              tileColor: Colors.transparent,
                              title: _setQuestionText(index)),
                        )),
                        Container(child: _answerCard(index)),
                        Container(child: _deleteQuestionBtn(index))
                      ],
                    )),
              ));
        });
  }

  returnAppBar() {
    Size size = MediaQuery.of(context).size;
    if (kIsWeb) {
      return AppBar(
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
      );
    } else {
      return AppBar(
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
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: returnAppBar(),
        body: Column(
          children: [
            Container(alignment: Alignment.center, child: _setQuizName()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [_saveQuizBtn()],
                ),
                Column(
                  children: [_newQuestionBtn()],
                )
              ],
            ),
            Expanded(child: Container(child: _questionCards()))
          ],
        ),
        backgroundColor: Colors.white);
  }
}
