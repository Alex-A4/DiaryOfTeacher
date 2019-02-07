import 'package:diary_of_teacher/src/ui/authorization/check_login.dart';
import 'package:flutter/material.dart';

//Start's point of the app
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diary of teacher',
      theme: theme,
      home: CheckLogin(),
    );
  }
}

final theme = ThemeData(
  primaryColor: Color(0xFFFFDEE0),
  accentColor: Color(0xFFFDF5E6),
  cursorColor: Color(0xFF9FDFDF),
  textSelectionColor: Color(0xFF9FDFDF),
  buttonColor: Color(0xFFFFE4E1),
  hintColor: Colors.black,
  textTheme: TextTheme(
    //For TextField
    body1: TextStyle(color: Colors.black, fontSize: 23.0,letterSpacing: 5.0),
    //For button's text
    body2: TextStyle(color: Colors.black, fontSize: 20.0, letterSpacing: 1.0),
  ),
);
