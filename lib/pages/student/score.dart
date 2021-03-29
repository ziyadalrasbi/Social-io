import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/pages/student/classroom.dart';

class Score extends StatefulWidget {
  final int score;

  const Score(this.score);
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  Widget _returnScore() {
    return Container(
      height: 350.0,
      width: 350.0,
      margin: EdgeInsets.all(25.0),
      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
      child: Center(
          child: Text(
        widget.score.toString()+"/10",
        style: TextStyle(fontSize: 100.0),
      )),
    );
  }

  Widget _returnToClassroomBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(4, 10, 120, 1.0),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        textStyle: TextStyle(fontSize: 30),
      ),
      child: Text('RETURN TO CLASSROOM'),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Classroom(),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _returnScore(),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_returnToClassroomBtn()],
              )
            ]));
  }
}
