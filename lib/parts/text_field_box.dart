import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';


// this is a text field box that goes on top of the input field box
// this just makes things easier as it can be done in one

class TextFieldBox extends StatelessWidget {
  final Widget child;
  final Color color;
  const TextFieldBox({
    Key key, 
    this.child,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    return Container(
      width: dimensions.width * 0.8, // making the dimensions, margins and padding of the box
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: color,
      ),
      child: child,
    );
  }
}