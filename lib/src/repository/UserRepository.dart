import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  ///Trying to sign in with google
  ///returns the FirebaseUser if success
  Future<Null> handleSignIn() async {
    ConnectivityResult res = await Connectivity().checkConnectivity();
    if (res == ConnectivityResult.none) {
      throw 'Отсутствует интернет соединение';
    }

    //For authentication
    FirebaseAuth _fbAuth = FirebaseAuth.instance;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    //If user not select an account
    if (googleUser == null) {
      throw 'Аккаунт не выбран';
    }

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user = await _fbAuth.signInWithCredential(credential);

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
        Firestore.instance.collection('users').document(user.uid).setData(
            {'photoUrl': user.photoUrl, 'id': user.uid, 'userName': userName});

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

      return;
    } else {
      throw 'Ошибка входа';
    }
  }

//Signing out user and clearing password hash
  Future<Null> handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('passwordHash');
  }

//Trying to login by comparing password's hash
  Future<Null> handleLogin(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int hash = prefs.getInt('passwordHash');

    //If password is correct
    if (password.hashCode == hash) {
      //Building user singleton
      await User.buildUser();
    } else {
      throw 'Пароль неверный';
    }
  }

//Check is user logged in by google and password exists
  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('passwordHash') != null && isLoggedIn) return true;
    return false;
  }

  //Save password hash to local storage
  Future<Null> savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Writing hashcode of password to stores

    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      Firestore.instance
          .collection('users')
          .document(prefs.getString('id'))
          .updateData({'passwordHash': password.hashCode});
    }

    prefs.setInt('passwordHash', password.hashCode);
  }

  //Save specified string value to local storage
  static Future saveStringToLocal(String keyName, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, value);
  }

  //Upload user image to cloud storage
  static Future uploadUserImage(File imageFile) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';

    StorageReference reference =
        FirebaseStorage.instance.ref().child(User.user.uid);
    StorageUploadTask uploadTask = reference.putFile(imageFile);

    try {
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String url = await storageTaskSnapshot.ref.getDownloadURL();

      User.user.photoUrl = url;
      await saveStringToLocal('photoUrl', url);
      await Firestore.instance
          .collection('users')
          .document(User.user.uid)
          .updateData({'photoUrl': url});
    } catch (err) {
      throw err;
    }
  }
}
