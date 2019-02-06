import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
      // Update data to server if new user
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .setData({'photoUrl': user.photoUrl, 'id': user.uid});

      // Write data to local
      print('UserId: ${user.uid}\nPhotoUrl: ${user.photoUrl}');
      await prefs.setString('id', user.uid);
      await prefs.setString('photoUrl', user.photoUrl);
    } else {
      // Write data to local
      await prefs.setString('id', documents[0]['id']);
      await prefs.setString('photoUrl', documents[0]['photoUrl']);
    }

    return user;
  } else {
    throw 'Ошибка входа';
  }
}