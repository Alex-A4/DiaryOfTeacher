import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Authentification extends StatefulWidget {
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Authentification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.clear();
            },
          )
        ],
      ),

      body: Container(
        child: Center(
          child: Text('Good luck'),
        ),
      ),
    );
  }
}