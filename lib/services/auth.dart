import 'package:crew_brew/models/user.dart';
import 'package:crew_brew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on UserCredential
  UserModel _userFromUserCredential(User? user) {
    return UserModel(uid: user?.uid);
  }

  //auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromUserCredential);
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      final UserCredential user = (await _auth.signInAnonymously());
      return _userFromUserCredential(user.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential user = (await _auth.signInWithEmailAndPassword(
          email: email, password: password));
      return _userFromUserCredential(user.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential user = (await _auth.createUserWithEmailAndPassword(
          email: email, password: password));

      //create a new document for the user with the uid
      await DatabaseService(uid: user.user!.uid)
          .updateUserData('0', 'new crew member', 100);
      return _userFromUserCredential(user.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
