import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_of_teacher/src/ui/authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SharedPreferences prefs;
  final GoogleSignIn _gsi = GoogleSignIn();
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  FirebaseUser currentUser;
  bool isLoading = false;
  bool isLoggedIn = false;

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState((){
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await _gsi.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _fbAuth.signInWithGoogle(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    if (user != null) {
      // Check is already signed up
      final QuerySnapshot result =
      await Firestore.instance
          .collection('users').where('id', isEqualTo: user.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .setData({'photoUrl': user.photoUrl, 'id': user.uid});

        // Write data to local
        currentUser = user;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      setState(() {
        isLoggedIn = true;
      });
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
        isLoggedIn = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return isLoggedIn ?
         getPasswordBuilding()
        : getSignIn();
  }


  final _formKey = GlobalKey<FormState>();
  String _password;
  var _passwordController = TextEditingController();

  Widget getPasswordBuilding() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(''),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/login_picture.jpg',
              fit: BoxFit.fitWidth,
            ),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Введите пароль'),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.numberWithOptions(),
                    validator: (pass) {
                      if (pass.isEmpty) return 'Введите пароль';
                    },
                    textAlign: TextAlign.center,
                    maxLength: 6,
                  ),

                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_)=> Authentification())
                        );
                      }
                    },
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget getSignIn() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Авторизация'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/login_picture.jpg',
                    fit: BoxFit.fitWidth,
                  ),

                  RaisedButton(
                    onPressed: handleSignIn,
                    child: Text('войти с помощью гугл'.toUpperCase()),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                  ),
                ],
              ),
            ),

            isLoading ?
            Center(child: CircularProgressIndicator(backgroundColor: Color(0xFFF0FFF0),),)
                : Container(),
          ],
        )
    );
  }


}