import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);
  
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  

  Future<String> logIn({String email, String pass}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
      return "signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String pass}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      return "signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}