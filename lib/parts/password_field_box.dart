import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/parts/text_field_box.dart';


// this class creates a password field box
// different from other text boxes

class PassField extends StatelessWidget {
  final ValueChanged<String> changes; // this is used for detecting changes in a text field
  final TextEditingController control; // this control is used later for confirming passwords
  final Function validate; // input validator function
  final String hint;
  final Color color;
  const PassField({
    Key key, 
    this.hint,
    this.color,
    this.control,
    this.changes,
    this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldBox(
      color: color,
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: validate,
        controller: control,
        obscureText: true, // this makes text hidden
        onChanged: changes,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}