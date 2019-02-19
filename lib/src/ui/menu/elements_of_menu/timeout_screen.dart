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
      body: RefreshIndicator(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 0),
          children: <Widget>[

          ],
        ),
        onRefresh: () async {
          print('Data refreshed');
        },
      ),
      drawer: MenuDrawer(),
    );
  }

  @override
  void initState() {
    super.initState();
    //TODO: add loading data
  }

  @override
  void dispose() {
    //TODO: add dispose data
    super.dispose();
  }
}