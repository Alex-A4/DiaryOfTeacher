import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:diary_of_teacher/src/controllers/lesson_controller.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:diary_of_teacher/src/repository/students_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  static final String userPhoto =
      'https://firebasestorage.googleapis.com/v0/b/diary-of-teacher-46bf7.appspot.com/o/login_picture.png?alt=media&token=876dc4f6-e42e-4a90-a812-d09ed6ccedbe';

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
        String photoUrl = user.photoUrl ?? userPhoto;
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
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      var prefs = await SharedPreferences.getInstance();
      prefs.remove('passwordHash');
    } catch (e) {
      throw 'Ошибка выхода. Проверьте интернет соединение и попробуйте ещё раз';
    }
  }

//Trying to login by comparing password's hash
  Future<Null> handleLogin(String password) async {
    //If password is correct build user and start work
    if (await checkPasswordCorrect(password)) {
      await User.buildUser();
      await StudentsRepository.buildRepo();
      await LessonController.buildController();
    } else
      throw 'Пароль неверный';
  }

  //Check password correctness and return true if ok and false if not
  Future<bool> checkPasswordCorrect(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int hash = prefs.getInt('passwordHash');

    //If password is correct
    if (password.hashCode == hash) {
      return true;
    } else {
      return false;
      ;
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
  Future saveStringToLocal(String keyName, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, value);
  }

  //Upload user image to cloud storage
  Future uploadUserImage(File imageFile) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';

    try {
      StorageReference reference =
          FirebaseStorage.instance.ref().child(User.user.uid);
      StorageUploadTask uploadTask = reference.putFile(imageFile);

      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String url = await storageTaskSnapshot.ref.getDownloadURL();

      User.user.photoUrl = url.toString();
      await saveStringToLocal('photoUrl', url.toString());
      await Firestore.instance
          .collection('users')
          .document(User.user.uid)
          .updateData({'photoUrl': url});
    } catch (err) {
      throw 'Ошибка загрузки';
    }
  }

  Future uploadUserName(String userName) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';
    await Firestore.instance
        .collection('users')
        .document(User.user.uid)
        .updateData({'userName': userName});

    await saveStringToLocal('userName', userName);

    User.user.userName = userName;
  }

  Future<void> initSettings() async {
    await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  }

  //Upload all data about lessons, students and groups to cloud firestore
  Future uploadAllDataToCloud() async {
    await StudentsRepository.getInstance()
        .saveToFirebase()
        .then((_) => LessonController.getInstance().saveToFirestore())
        .catchError((err) => throw err.toString());
  }

  //Restore all data about lessons, students and groups from cloud firestore
  Future restoreAllDataFromCloud() async {
    await StudentsRepository.getInstance()
        .restoreFromFirebase()
        .then(
            (_) => LessonController.getInstance().restoreLessonsFromFirestore())
        .catchError((error) => throw error);
  }
}
