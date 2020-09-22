import 'package:flutter/cupertino.dart';
import 'package:tutorappnew/services/database.dart';
import 'package:tutorappnew/models/user.dart';
import 'package:tutorappnew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

//create a user object based on FirebaseUser
  User userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

// auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(userFromFirebaseUser);
  }

//signin with google
  Future signInWithGoogle(String userType, BuildContext context) async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      newUserDocument(user, userType, context);
      return user;
    } catch (e) {
      return null;
    }
  }

// sign out
  Future signOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void newUserDocument(
      FirebaseUser user, String userType, BuildContext context) async {
// create a new document for the user with the uid
    return await DatabaseService(uid: user.uid)
        .checkTheUser(user.uid, userType, user.displayName);
  }

//get current user details
  Future getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    String name = 'Name',
        uid = '123',
        url = 'null',
        phoneno = '123456789',
        email = '';
    if (user != null) {
      name = user.displayName;
      url = user.photoUrl;
      uid = user.uid;
      phoneno = user.phoneNumber;
      email = user.email;
      Map data = {'1': uid, '2': name, '3': url, '4': phoneno, '5': email};
      return data;
    } else {
      Map data = {'1': uid, '2': name, '3': url, '4': phoneno, '5': email};
      return data;
    }
  }
}
