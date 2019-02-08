import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:diary_of_teacher/src/ui/authorization/sign_in.dart';
import 'package:diary_of_teacher/src/ui/main/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  ///Trying to sign in with google
  ///returns the FirebaseUser if success
  Future<FirebaseUser> handleSignIn() async {
    ConnectivityResult res = await Connectivity().checkConnectivity();
    if (res == ConnectivityResult.none) {
      throw 'Отсутствует интернет соединение';
    }

    //For authentication
    GoogleSignIn _gsi = GoogleSignIn();
    FirebaseAuth _fbAuth = FirebaseAuth.instance;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    GoogleSignInAccount googleUser = await _gsi.signIn();
    //If user not select an account
    if (googleUser == null) {
      throw 'Аккаунт не выбран';
    }

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _fbAuth.signInWithGoogle(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    if (user != null) {
      // Check is already signed up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        String userName = user.displayName ?? 'User';
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .setData({'photoUrl': user.photoUrl, 'id': user.uid, 'userName': userName});

        // Write data to local
        await prefs.setString('id', user.uid);
        await prefs.setString('photoUrl', user.photoUrl);
        await prefs.setString('userName', userName);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('userName', documents[0]['userName']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
      }

      return user;
    } else {
      throw 'Ошибка входа';
    }
  }

//Signing out user and clearing password hash
  Future<Null> handleSignOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('passwordHash');
    });
    //TODO: replace this logic to AuthBloc
    //.then((_) => Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder: (context) => SignIn()),
//            (Route<dynamic> route) => false));
  }

//Trying to login by comparing password's hash
  Future<Null> handleLogin(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int hash = prefs.getInt('passwordHash');

    //If password if correct
    if (password.hashCode == hash) {
      //Building user singleton
      await User.buildUser();

      //TODO: replace this logic to AuthBloc
//      Navigator.of(context).pushReplacement(MaterialPageRoute(
//          builder: (_) =>
//              ProfileScreen()));
    } else {
      throw 'Пароль неверный';
    }
  }

//Check is user logged in by google and password exists
  Future<bool> isLoggedIn() async {
    final GoogleSignIn _gsi = GoogleSignIn();
    bool isLoggedIn = await _gsi.isSignedIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('passwordHash') != null && isLoggedIn) return true;
    return false;
  }

}