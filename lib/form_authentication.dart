import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);
  
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }


  Future<String> logIn({String email, String pass}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
      return "signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  

  
}

Future<void> signUp(String userName, String email, String accType, int followers, int following, 
List followerslist, List followinglist, String profilepic, List likedposts, String appbar, 
String banner, String border, int totallikes, List savedposts, bool isDark, List rewards) async {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser.uid.toString();
      users.add({
        'username': userName,
        'email': email,
        'accType': accType,
        'followers': followers,
        'following': following,
        'uid': uid,
        'followerslist': followerslist,
        'followinglist': followinglist,
        'profilepic': profilepic,
        'likedposts': likedposts,
        'appbar': appbar,
        'banner': banner,
        'border': border,
        'totallikes': totallikes,
        'savedposts': savedposts,
        'isDark': isDark,
        'rewards': rewards,
      });
      return;
}

  
  