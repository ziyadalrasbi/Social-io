import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/pages/student/classroom.dart';
import 'package:socialio/pages/student/quiz.dart';

class Viewquizzes extends StatefulWidget {
  @override
  _ViewQuizState createState() => _ViewQuizState();
}

class QuizPick {
  String quizName;
  QuizPick({this.quizName});
}

class _ViewQuizState extends State<Viewquizzes> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    getQuizzes();
    super.initState();
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
          return Dismissible(
            key: ObjectKey(item),
            onDismissed: (direction) {
              setState(() {
                listOfQuizzes.removeAt(index);
              });
            },
            child: Card(
                color: Color.fromRGBO(4, 10, 120, 1.0),
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        tileColor: Colors.grey,
                        title: Text(listOfQuizzes[index].toString()),
                        trailing: IconButton(
                          icon: Image.asset('assets/icons/ICON_Tick.png'),
                          iconSize: 25,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Quiz(listOfQuizzes[index]),
                                ));
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          );
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
      body: Column(
        children: [Expanded(child: Container(child: _quizPicker()))],
      ),
    );
  }
}
