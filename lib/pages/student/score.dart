import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/pages/student/classroom.dart';

class Score extends StatefulWidget {
  final int score;
  final int outOf;

  const Score(this.score, this.outOf);
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  Widget _returnScore() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.7,
      width: size.width*0.7,
      margin: EdgeInsets.all(25.0),
      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
      child: Center(
          child: Text(
        widget.score.toString()+ "/" + widget.outOf.toString(),
        style: TextStyle(fontSize: 100.0),
      )),
    );
  }

  Widget _returnToClassroomBtn() {
   Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(4, 10, 120, 1.0),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          textStyle: TextStyle(fontSize: 18),
        ),
        child: Text('RETURN TO CLASSROOM'),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Classroom(),
              ));
        },
      ),
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
                image: AssetImage(Constants.myAppBar.toString()),
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
