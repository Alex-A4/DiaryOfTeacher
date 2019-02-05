import 'package:diary_of_teacher/src/ui/check_login.dart';
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
  primaryColor: Color(0xFFFFF0F5),
  accentColor: Color(0xFFFDF5E6),
);