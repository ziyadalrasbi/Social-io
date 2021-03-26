import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialio/database.dart';
import 'package:socialio/extra/chatpage/chat_page.dart';
import 'package:socialio/form_authentication.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/login/parts/background.dart';

import 'package:socialio/pages/signup/sign_up_second.dart';
import 'package:socialio/parts/account_recheck.dart';
import 'package:socialio/parts/button.dart';
import 'package:socialio/parts/input_field_box.dart';
import 'package:socialio/parts/password_field_box.dart';


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
      child: SingleChildScrollView(
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
                      return "Must be a valid email.";
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
                  HelperFunction.saveUserFollowersSharedPref(querySnapshot.docs[0].data()['followers']);
                  HelperFunction.saveUserFollowingSharedPref(querySnapshot.docs[0].data()['following']);
                  HelperFunction.saveProfilePicSharedPref(querySnapshot.docs[0].data()['profilepic']);
                  HelperFunction.saveProfileBarSharedPref(querySnapshot.docs[0].data()['appbar']);
                  HelperFunction.saveProfileBorderSharedPref(querySnapshot.docs[0].data()['border']);
                  HelperFunction.saveProfileBannerSharedPref(querySnapshot.docs[0].data()['banner']);
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
