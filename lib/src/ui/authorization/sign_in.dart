import 'package:diary_of_teacher/src/ui/authorization/password_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../network/authorization.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseUser currentUser;
  bool isLoading = false;
  bool isLoggedIn = false;

  Future<FirebaseUser> userFuture;


  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? PasswordBuilder(currentUser.uid) : getSignIn();
  }

  //Screen to sign in with Google
  Widget getSignIn() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Авторизация'),
        ),
        body: FutureBuilder(
          future: userFuture,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              currentUser = snapshot.data;
              setState(() {
                isLoading = false;
                isLoggedIn = true;
              });
            }
            if (snapshot.hasError) {
              setState(() {
                isLoading = false;
              });
            }

            return Stack(
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
                        height: 50.0,
                      ),
                      RaisedButton(
                        onPressed: (){
                          userFuture = handleSignIn();
                          setState(() {
                            isLoading = true;
                          });
                        },
                        child: Text('войти с помощью гугл'.toUpperCase()),
                        elevation: 5.0,
                        color: Color(0xFFFFE4E1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xFFF0FFF0),
                  ),
                )
                    : Container(),
              ],
            );
          },
        ),
    );
  }
}
