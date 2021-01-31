import 'package:flutter/material.dart';



// the background of the welcome screen page
// things such as patterns or colours can go here on the background
// this section is overlapped by the body



class Background extends StatelessWidget {
  final Widget child;
  const Background ({
    Key key,
    @required this.child,
  }) : super(key: key);

  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.white,Colors.purple[300], Colors.blue,])
      ),
      
      width: double.infinity,
      height: dimensions.height,
      child: Stack(
        
        alignment: Alignment.center,
        children: <Widget>[
          // over here we can put background pictures
          child,
        ],
        )
    );
  }
}