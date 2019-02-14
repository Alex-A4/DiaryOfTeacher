import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:flutter/material.dart';


class GroupsListView extends StatefulWidget {
  @override
  _GroupsListViewState createState() => _GroupsListViewState();
}

class _GroupsListViewState extends State<GroupsListView> {
  StudentsController _controller = StudentsController.getInstance();
  PageStorageKey _key = PageStorageKey('GroupsListKey');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        key: _key,
        itemCount: _controller.listOfGroups.length,
        itemBuilder: (context, index){
          var group = _controller.listOfGroups[index];
          return ListTile(
            onTap: (){print(group.name);},
            title: Text(group.name, style: theme.textTheme.body1),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Button pressed');
        },
        tooltip: 'Создать группу',
        child: Icon(Icons.add),
      ),
    );
  }
}
