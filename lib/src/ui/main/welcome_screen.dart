import 'package:diary_of_teacher/src/ui/authorization/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';


class WelcomeScreen extends StatefulWidget {
  final String uid;
  final String photoUrl;

  WelcomeScreen(this.uid, this.photoUrl);

  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добро пожаловать'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: handleSignOut,
          )
        ],
      ),

      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.photoUrl,
              placeholder: Container(child: CircularProgressIndicator(backgroundColor: Color(0xFFDFFAF0),)),
              width: 300.0,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }


  Future<Null> handleSignOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignIn()),
            (Route<dynamic> route) => false);
  }
}