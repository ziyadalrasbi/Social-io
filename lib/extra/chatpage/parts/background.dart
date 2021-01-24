import 'package:flutter/material.dart';



class Background extends StatelessWidget {
  final Widget child;
  
  final Widget body;
  Background({
    Key key, 
    this.body,
    @required this.child
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    Size dimensions = MediaQuery.of(context).size;
    return Container(
      height: dimensions.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          child,
          body,
        ],
      )
    );
  }
}