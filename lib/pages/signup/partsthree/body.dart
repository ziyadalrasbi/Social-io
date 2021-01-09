import 'package:flutter/material.dart';
import 'package:login_page/pages/home/home_page.dart';
import 'package:login_page/pages/signup/partsthree/background.dart';
import 'package:login_page/parts/button.dart';
import 'package:login_page/parts/input_field_box.dart';
import 'package:email_validator/email_validator.dart';
import 'package:login_page/parts/password_field_box.dart';

// the last sign up page that asks for the final details
// different types of validation used here
class Body extends StatelessWidget {
  final Widget child;
  static final validNameCharacters = RegExp(r'^([A-Za-z])+$'); // these are the valid characters that a first/last name can have, which is only letter
  static final validEmailCharacters = RegExp(r'^[a-zA-Z0-9.@]+$'); // valid email characters
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // a form key for input validation
  final TextEditingController _pass = TextEditingController(); // this is used for the password/confirm password section. this is only used if you need to confirm password
  final TextEditingController _confirmPass = TextEditingController(); // same as above
  Body({
    Key key, 
    @required this.child
    }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Finally, enter the following details."
              ),
              InputField(
                type: TextInputType.name,
                validate: (value) {
                  if (value.isEmpty) {
                    return "This can't be empty.";
                  }
                  if(!validNameCharacters.hasMatch(value)) {            // first check for first name, just simple validation
                    return "No special characters allowed in name.";
                  }
                  if (value.length < 2) {
                    return "Name must be at least 2 characters.";
                  }
                },
                hint: "First name",
                changes: (value) {},
              ),
              InputField(
                validate: (value) {
                  if (value.isEmpty) {
                    return "This can't be empty.";
                  }
                  if(!validNameCharacters.hasMatch(value)) {
                    return "No special characters allowed in name.";    // exact same validation for second name
                  }
                  if (value.length < 2) {
                    return "Name must be at least 2 characters.";
                  }
                },
                hint: "Last name",
                changes: (value) {},
              ),
              InputField(
                validate: (value) {
                  final bool isValid = EmailValidator.validate(value); // flutter has an EmailValidator function that lets you validate emails with a boolean
                  if (!isValid) {
                    return "Email invalid. Please re-enter."; // if it is NOT valid, return that it is not a valid email
                  }
                },
                hint: "Email",
                changes: (value) {},
              ),
              InputField( // the mobile number text field
                type: TextInputType.number, // this makes sure that only integers are taken in this text field
                validate: (value) {
                  if (value == null) {
                    return "Invalid number. Please re-enter."; // if value is null, return this
                  }
                  final n = num.tryParse(value);
                  if (n == null) {
                    return '"$value" is an invalid number. Please re-enter.'; // if the number is invalid, return this
                  }
                  return null;
                },
                hint: "Mobile number",
                changes: (value) {},
              ),
              PassField( // the first "enter password" field
                control: _pass, // the first controller is used here
                validate: (value) {
                  if (value.isEmpty) {
                    return "Password cannot be empty."; // check that passwords cant be empty
                  }
                  if (value.length < 6) {
                    return "Password cannot be less than 6 characters."; // passwords cant be less than 6 and greater than 15 characters
                  }
                  if (value.length > 15) {
                    return "Password cannot be greater than 15 characters.";
                  }
                  return null;
                },
                changes: (value) {},
              ),
              PassField( // this is the "confirm password" field
                control: _confirmPass, // the controller for the confirm pass
                validate: (value) {
                  if (value.isEmpty) {
                    return "Password cannot be empty."; // makes sure that it is not empty
                  }
                  if (value != _pass.text) {
                    return "Passwords do not match."; // now, check if the value is equal to the previous password field. this is why the controller is used, to connect them
                  }
                  return null;
                },
                changes: (value) {},
              ),
              MainButton( // final sign up button
                text: "Sign up",
                pressed: () {
                  _formKey.currentState.validate() // form key to validate all the info
                  ? Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context){
                          return HomePage(); 
                        }, 
                      ),
                    )
                  : Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("This is not a valid.")));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}