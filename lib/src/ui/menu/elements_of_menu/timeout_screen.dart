import 'package:diary_of_teacher/src/ui/menu/elements_of_menu/drawer.dart';
import 'package:flutter/material.dart';

class TimeoutScreen extends StatefulWidget{
  _TimeoutState createState() => _TimeoutState();
}

class _TimeoutState extends State<TimeoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Перерыв'),
      ),
      body: Container(

      ),
      drawer: MenuDrawer(),
    );
  }
}