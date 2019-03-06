import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:diary_of_teacher/src/ui/menu/students_subelements/groups_list.dart';
import 'package:diary_of_teacher/src/ui/menu/students_subelements/students_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentsScreen extends StatefulWidget {
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<StudentsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  StudentsController _controller = StudentsController.getInstance();

  static const List<String> _tabs = ['Ученики', 'Группы'];

  List<Widget> _lists = [StudentsListView(), GroupsListView()];

  //TODO: add button to look at archived students

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
              BlocProvider.of<AuthenticationBloc>(context)
                  .userRepository
                  .uploadAllDataToCloud()
                  .then((_) {
                Fluttertoast.showToast(msg: 'Данные загужены в облако');
              }).catchError((error) {
                Fluttertoast.showToast(msg: error);
              });
            },
            icon: Icon(Icons.cloud_upload),
            tooltip: 'Загрузить данные в облако',
          ),
        ],
        bottom: TabBar(
          tabs: _tabs
              .map((tab) => Tab(
                    text: tab,
                  ))
              .toList(),
          controller: _tabController,
          labelStyle: TextStyle(
              fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w700),
          unselectedLabelStyle:
              TextStyle(fontSize: 18.0, color: Colors.black26),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _lists.map((element) => element).toList(),
      ),
      drawer: MenuDrawer(),
    );
  }
}
