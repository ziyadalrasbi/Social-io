import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/database.dart';
import 'package:login_page/extra/chatpage/chat_page.dart';
import 'package:login_page/helpers.dart';
import 'package:login_page/pages/login/parts/background.dart';
import 'package:login_page/pages/signup/sign_up_first.dart';
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login (maybe a picture here or just a nice font)"
          ),
          InputField(
            key: _formKey,
            control: emailController,
            hint: "Email address",
            
          ),
          PassField(
            control: passController,
            hint: "Password"
            
          ),
          MainButton(
            text: "Log In",
            pressed: () async {
              if (_formKey.currentState.validate()) {
              HelperFunction.saveUserEmailSharedPref(emailController.text);
              setState(() {
                isLoading = true;   
              });
              databaseMethods.getEmail(emailController.text)
              .then((val){
                querySnapshot = val;
                HelperFunction.saveUserNameSharedPref(querySnapshot.docs[0].data()['username']);
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
              }
            },
          ),
          AccountRecheck(
            pressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpFirst();
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
