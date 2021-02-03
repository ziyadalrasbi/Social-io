import 'package:flutter/material.dart';

// the main button class that creates a button

class MainButton extends StatelessWidget {
  final String text;
  
  final Color color, textColor;
  final Function pressed;
  MainButton({
    Key key, // each button has a unique key
    this.text, // text inside the button
    this.pressed, // a function called 'pressed' that does something when a button is pressed
    this.color, // the colour of the button
    this.textColor, // the text colour on the button
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size; // this gets the size of the screen so it is easy to compare to
    return Container( // a container that holds the different information about the buttion dimensions
      width: dimensions.width * 0.8, // width of the button
      
      margin: EdgeInsets.symmetric(vertical: 16), // the margin of the button, making space below and above it
      child: ClipRRect( // ClipRRect makes a child be bound to a rectangle. for neatness, helpful for the buttons
        child: FlatButton(
        
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            
          ),
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20), // padding of the buttons
          color: color, // colour of the button
          onPressed: pressed, // when a button is pressed, the 'pressed' function is called
          child: Text( // the text on the button
            text,
            style: TextStyle(color: textColor, fontSize: 15),
            
          ),
        ),
      ),
    );
  }
}