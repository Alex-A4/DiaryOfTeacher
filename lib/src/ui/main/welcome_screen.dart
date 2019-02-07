import 'package:diary_of_teacher/src/models/user.dart';
import 'package:diary_of_teacher/src/network/authorization.dart';
import 'package:diary_of_teacher/src/ui/authorization/sign_in.dart';
import 'package:diary_of_teacher/src/ui/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen();

  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: User.user.userName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Добро пожаловать'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: (){
                handleSignOut(context);
              },
            )
          ],
        ),
        drawer: MyDrawer(),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(User.user.photoUrl),
                        radius: 100,
                      ),
                    ),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          print('Button tapped');
                        },
                        iconSize: 80.0,
                        color: Colors.white70,
                        icon: Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Введите имя'),
              ),
            ],
          ),
        ));
  }
}
