import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialio/parts/text_field_box.dart';


// this is a field box that takes an input from a user

class InputField extends StatelessWidget {
  final Color color;
  final String hint; // the hint text, that goes on top of the text box
  final Function validate; // a validator function that is used to validate different inputs
  final TextEditingController control;
  final TextInputType type; // the input type for a field (e.g. integer, string, date etc.)
  final ValueChanged<String> changes; // this is used to detect the changes, good for async validation
  InputField({
    Key key,
    this.hint,
    this.color,
    this.validate,
    this.type,
    this.control,
    this.changes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldBox(
      color: color,
      child: TextFormField(
        // style: style,
        controller: control,
        validator: validate, 
        onChanged: changes,
        keyboardType: type,
        decoration: InputDecoration(
          border: InputBorder.none, // making it have no border
          hintText: hint,
        ),
      ),
    );
  }
}