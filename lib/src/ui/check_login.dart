import 'package:diary_of_teacher/src/ui/authentification.dart';
import 'package:diary_of_teacher/src/ui/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';



// Checks is user already logged in
class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GoogleSignIn _gsi = GoogleSignIn();

  bool isLoggedIn = false;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    isLoggedIn = await _gsi.isSignedIn();
    if (isLoggedIn)
      setState(() {
      });

    this.setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? Container()
        : isLoggedIn ? Authentification()
        : SignIn();
  }
}