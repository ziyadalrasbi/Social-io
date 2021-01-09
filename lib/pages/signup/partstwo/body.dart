import 'package:flutter/material.dart';
import 'package:login_page/pages/signup/partstwo/background.dart';
import 'package:login_page/pages/signup/sign_up_third.dart';
import 'package:login_page/parts/button.dart';
import 'package:login_page/parts/input_field_box.dart';

// this is the second sign up page
// this page asks a user to enter their desired username
// validation is done here

class Body extends StatelessWidget {
  static final validCharacters = RegExp(r'^[a-zA-Z0-9.]+$'); // a list of valid characters in a username (letters, numbers and full stops)
  final Widget child;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // this key is used for validation. once the "Next" button is pressed, this key checks if the information is valid
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
          key: _formKey, // making a key variable here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Enter a unique username. This will be displayed to other users."
              ),
              InputField( // the input field to enter a usernamer
                validate: (value) {
                  if (value.isEmpty) { 
                    return "This can't be empty."; // if the field is empty, return this
                  }
                  if(!value.contains(validCharacters)) {
                    return "No special characters allowed in username."; // if the field has invalid characters (e.g. !,?@#) return this
                  }
                  if (value.length < 3) {
                    return "Usernames must be at least 3 characters."; // if the username is less than 3 characters, return this
                  }
                },
                hint: "Username", // the hint text of the field
                changes: (value) {},
              ),
              MainButton( // this is the "Next" button
                text: "Next",
                pressed: () {
                  _formKey.currentState.validate() // the key made before is used here, and it validates the input of the text field
                  ? Navigator.push( // the ? is basically if/else. so if it is valid, continue to the next sign up page 
                      context, 
                      MaterialPageRoute(
                        builder: (context){
                          return SignUpThird();
                        }, 
                      ),
                    )
                  : Scaffold.of(context).showSnackBar( // and the : is else. else, return that it is invalid
                    SnackBar(content: Text("This is not valid."))); 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
