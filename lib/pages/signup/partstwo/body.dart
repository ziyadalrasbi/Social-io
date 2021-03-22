import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialio/database.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/login/login_screen.dart';
import 'package:socialio/pages/signup/partstwo/background.dart';
import 'package:socialio/parts/account_recheck.dart';
import 'package:socialio/parts/button.dart';
import 'package:socialio/parts/input_field_box.dart';
import 'package:email_validator/email_validator.dart';
import 'package:socialio/parts/password_field_box.dart';
import 'package:socialio/form_authentication.dart';

// the last sign up page that asks for the final details
// different types of validation used here
class Body extends StatefulWidget {
 @override
 _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String dropdownValue = "User";
  Widget child;
  static final validNameCharacters = RegExp(r"^[a-zA-Z0-9.]*$"); // these are the valid characters that a first/last name can have, which is only letter
  static final validEmailCharacters = RegExp(r'^[a-zA-Z0-9.@]+$'); // valid email characters
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // a form key for input validation
  final TextEditingController _pass = TextEditingController(); // this is used for the password/confirm password section. this is only used if you need to confirm password
  final TextEditingController _confirmPass = TextEditingController(); // same as above
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController accTypeController = TextEditingController();
  bool isLoading = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  int userfollowers = 0;
  int userfollowing = 0;
  List followerslist = [];
  List followinglist = [];
  List likedposts = [];
  String profilepic = "assets/images/wrestler.png";
  printEmailError() {
    print("This email is already in use");
  }

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
               InputField(
                 color: Colors.white,
                type: TextInputType.name,
                validate: (value) {
                  if (value.isEmpty) {
                    return "This can't be empty.";
                  }
                  if(!validNameCharacters.hasMatch(value)) {            // first check for first name, just simple validation
                    return "No special characters allowed in username, only full stops.";
                  }
                  if (value.length < 2) {
                    return "Usernames must be at least 2 characters.";
                  }
                },
                hint: "Username",
                control: usernameController,
                changes: (value) {},
              ),
              InputField(
                color: Colors.white,
                validate: (value) {
                  final bool isValid = EmailValidator.validate(value); // flutter has an EmailValidator function that lets you validate emails with a boolean
                  if (!isValid) {
                    return "Email invalid. Please re-enter."; // if it is NOT valid, return that it is not a valid email
                  }
                },
                hint: "Email",
                control: emailController,
                changes: (value) {},
              ),
              PassField( // the first "enter password" field
                color: Colors.white,
                control: _pass,
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
                  
                },
                // the first controller is used here
                hint: "Password",
                changes: (value) {},
              ),
              PassField( // this is the "confirm password" field
                color: Colors.white,
                control: _confirmPass,
                validate: (value) {
                  if (value.isEmpty) {
                    return "Password cannot be empty."; // makes sure that it is not empty
                  }
                  if (value != _pass.text) {
                    return "Passwords do not match."; // now, check if the value is equal to the previous password field. this is why the controller is used, to connect them
                  }
                  
                },
                hint: "Confirm password",
                 // the controller for the confirm pass
                changes: (value) {},
              ),
              Container(
                height: 8,
              ),
              Container(
                width: dimensions.width * 0.8,
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                
                child: DropdownButton(
                isExpanded: true,
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down_circle),
                iconSize: 20,
                elevation: 15,
                underline: Container(
                  
                  height: 2
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;                  
                  });
                },
                items: <String>[
                  "User", "Creator", "Student"
                ].map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                ),
              ),

              MainButton( 
                // final sign up button
                text: "Sign up",
                textColor: Colors.white,
                color: Colors.indigo[500],
                pressed: () async {
                  // form key to validate all the info
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                  HelperFunction.saveUserEmailSharedPref(emailController.text);
                  HelperFunction.saveUserNameSharedPref(usernameController.text);
                  HelperFunction.saveUserTypeSharedPref(dropdownValue);
                  HelperFunction.saveUserFollowersSharedPref(userfollowers);
                  HelperFunction.saveUserFollowingSharedPref(userfollowing);
                  HelperFunction.saveProfilePicSharedPref(profilepic);
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      isLoading = true;              
                    });
                  }
                  
                  try {
                   
                    
                    UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: _pass.text,
                    );
                    User updateUser = FirebaseAuth.instance.currentUser;
                    updateUser.updateProfile(
                      displayName: usernameController.text,
                    );
                    signUp(
                      usernameController.text,
                      emailController.text,
                      dropdownValue.toString(),
                      userfollowers,
                      userfollowing,
                      followerslist,
                      followinglist,
                      profilepic,
                      likedposts
                      );
                  } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      } 
                  } catch (e) {
                    print(e);
                  }
                  HelperFunction.saveLoggedInSharedPref(true);
                }
                },
              ),
              AccountRecheck(
                logged: false,
                pressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      }
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}