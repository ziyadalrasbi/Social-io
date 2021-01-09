import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_page/parts/text_field_box.dart';


// this is a field box that takes an input from a user

class InputField extends StatelessWidget {
  final String hint; // the hint text, that goes on top of the text box
  final Function validate; // a validator function that is used to validate different inputs
  final TextInputType type; // the input type for a field (e.g. integer, string, date etc.)
  final ValueChanged<String> changes; // this is used to detect the changes, good for async validation
  InputField({
    Key key,
    this.hint,
    this.validate,
    this.type,
    this.changes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldBox(
      child: TextFormField(
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