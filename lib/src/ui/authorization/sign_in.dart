import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/ui/authorization/password_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../network/authorization.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseUser currentUser;

  Future<FirebaseUser> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: userFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          currentUser = snapshot.data;
          Fluttertoast.showToast(msg: "Вход выполнен успешно");
          return PasswordBuilder(currentUser.uid);
        } else if (snapshot.hasError) {
          Fluttertoast.showToast(msg: snapshot.error.toString());
        }

        return getSignIn();
      },
    );
  }

  //Screen to sign in with Google
  Widget getSignIn() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Авторизация'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/login_picture.png',
                    height: 200.0,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                      });
                      userFuture = handleSignIn();
                    },
                    child: Text(
                      'войти с помощью гугл'.toUpperCase(),
                      style: theme.textTheme.body2,
                    ),
                    elevation: 5.0,
                    color: theme.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
