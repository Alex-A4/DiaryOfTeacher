import 'package:diary_of_teacher/src/ui/menu/drawer.dart';
import 'package:flutter/material.dart';


class StudentsScreen extends StatefulWidget{
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<StudentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ученики'),
      ),
      body: Container(

      ),
      drawer: MenuDrawer(),
    );
  }
}