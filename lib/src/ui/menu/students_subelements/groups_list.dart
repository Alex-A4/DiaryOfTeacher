import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:flutter/material.dart';

class GroupsListView extends StatefulWidget {
  @override
  _GroupsListViewState createState() => _GroupsListViewState();
}

class _GroupsListViewState extends State<GroupsListView> {
  StudentsController _controller = StudentsController.getInstance();
  PageStorageKey _key = PageStorageKey('GroupsListKey');
  TextEditingController _groupNameController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        key: _key,
        itemCount: _controller.listOfGroups.length,
        itemBuilder: (context, index) {
          var group = _controller.listOfGroups[index];
          return ListTile(
            onTap: () {
              print(group.name);
            },
            title: Text(group.name, style: theme.textTheme.body1),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showGroupNamePicker,
        tooltip: 'Создать группу',
        child: Icon(Icons.add),
      ),
    );
  }

  void showGroupNamePicker() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 200.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Введите название группы',
                    style: theme.textTheme.display2,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _groupNameController,
                      maxLength: 20,
                      style: theme.textTheme.body2,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      StudentsController.getInstance()
                          .addNewGroup(Group(_groupNameController.text));
                      _groupNameController.clear();
                      Navigator.of(context).pop();
                      setState(() {
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    elevation: 6.0,
                    highlightColor: theme.primaryColor,
                    child: Text(
                      'Создать',
                      style: theme.textTheme.display2,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
