import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/student.dart';
import 'package:diary_of_teacher/src/ui/menu/students_subelements/StudentEditor.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentsScreen extends StatefulWidget {
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<StudentsScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  StudentsController _controller = StudentsController.getInstance();

  static const List<String> _tabs = ['Ученики', 'Группы'];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ученики'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _controller.saveDataToFirebase().then((_) {
                Fluttertoast.showToast(msg: 'Данные сохранены');
              }).catchError((error) {
                Fluttertoast.showToast(msg: error);
              });
            },
            icon: Icon(Icons.cloud_upload),
            tooltip: 'Сохранить на диск',
          ),
        ],
        bottom: TabBar(
          tabs: _tabs.map((tab) => Tab(text: tab,)).toList(),
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        //Add students list or groups list
      ),

      drawer: MenuDrawer(),
    );
  }
}
