import 'package:diary_of_teacher/src/ui/login.dart';
import 'package:diary_of_teacher/src/ui/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';



// Checks is user already logged in
class CheckLogin extends StatefulWidget {

  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
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
        : isLoggedIn ? LogIn()
        : SignIn();
  }
}