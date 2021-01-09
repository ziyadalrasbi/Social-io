import 'package:flutter/material.dart';


class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: dimensions.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget> [
          child,
        ],
      ),
    );
  }
}