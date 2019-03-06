import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget{
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
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