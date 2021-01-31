import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/database.dart';
import 'package:login_page/extra/chatpage/chat_page.dart';
import 'package:login_page/form_authentication.dart';
import 'package:login_page/helpers.dart';
import 'package:login_page/pages/login/parts/background.dart';

import 'package:login_page/pages/signup/sign_up_second.dart';
import 'package:login_page/parts/account_recheck.dart';
import 'package:login_page/parts/button.dart';
import 'package:login_page/parts/input_field_box.dart';
import 'package:login_page/parts/password_field_box.dart';


// the login page

class Body extends StatefulWidget {
 @override
 _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isLoading = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot querySnapshot;
  


  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        key: _formKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          
          InputField(
            color: Colors.white,
            validate: (value) {
                  if (value.isEmpty) {
                    return "This can't be empty.";
                  }
                  
                  if (value.length < 2) {
                    return "Usernames must be at least 2 characters.";
                  }
            },
            control: emailController,
            hint: "Email address",
            
          ),
          PassField(
            color: Colors.white,
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
            control: passController,
            hint: "Password",
            
          ),
          MainButton(
            text: "Log In",
            textColor: Colors.white,
              color: Colors.indigo[500],
            pressed: () async {
              HelperFunction.saveUserEmailSharedPref(emailController.text);
              setState(() {
                isLoading = true;   
              });
              databaseMethods.getEmail(emailController.text)
              .then((val){
                querySnapshot = val;
                HelperFunction.saveUserNameSharedPref(querySnapshot.docs[0].data()['username']);
                HelperFunction.saveUserTypeSharedPref(querySnapshot.docs[0].data()['accType']);
              }); 
              try {
                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passController.text
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }
              HelperFunction.saveLoggedInSharedPref(true);
              
            },
          ),
          AccountRecheck(
            pressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpSecond();
                  }
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
 










// validateLogin() {
//     if (formKey.currentState.validate()) {
//       HelperFunction.saveUserEmailSharedPref(emailController.text);
//       setState(() {
//         isLogged = true;   
//       });
//       HelperFunction.saveLoggedInSharedPref(true);
//       Navigator.pushReplacement(
//         context, 
//         MaterialPageRoute(
//           builder: (context) => ChatPage(),
//         ),
//       );
//     }
//   }
