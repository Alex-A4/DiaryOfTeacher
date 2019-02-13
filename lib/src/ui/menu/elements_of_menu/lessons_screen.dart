import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:flutter/material.dart';

class LessonsScreen extends StatefulWidget{
  _LessonsState createState() => _LessonsState();
}

class _LessonsState extends State<LessonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Уроки'),
      ),
      body: Container(

      ),
      drawer: MenuDrawer(),
    );
  }
}