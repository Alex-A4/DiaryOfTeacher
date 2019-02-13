import 'package:cached_network_image/cached_network_image.dart';
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

class _StudentsState extends State<StudentsScreen> {
  StudentsController _controller = StudentsController.getInstance();
  PageStorageKey _key = PageStorageKey('StudentsListKey');

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
      ),
      body: ListView.builder(
        key: _key,
        itemCount: _controller.listOfStudents.length,
        itemBuilder: (context, index) {
          Student student = _controller.listOfStudents[index];

          return ListTile(
            onTap: () {
              _openStudentEditor(context, false, student: student);
            },
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(student.photoUrl),
            ),
            title: Text(
              student.fio,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.display2,
            ),
            subtitle: Text(
              _controller.getGroupNameById(student.groupId),
              style: theme.textTheme.display3,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  tooltip: 'В архив',
                  icon: Icon(Icons.archive),
                  onPressed: () {
                    acceptAction('Добавить в архив?',
                        'Вы действительно хотите добавиь ученика в архив?', () {
                      _controller.archiveStudent(student).then((_) {
                        Fluttertoast.showToast(msg: 'Ученик добавлен у архив');
                        setState(() {});
                      }).catchError(
                          (error) => Fluttertoast.showToast(msg: error));
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Удалить',
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    acceptAction('Удалить?',
                        'Вы действительно хотите удалить этого ученика безвозвратно?',
                        () {
                      _controller.deleteStudent(student).then((_) {
                        Fluttertoast.showToast(msg: 'Ученик удален');
                        setState(() {});
                      }).catchError(
                          (error) => Fluttertoast.showToast(msg: error));
                    });
                  },
                ),
              ],
            ),
          );
        },
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      ),
      drawer: MenuDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openStudentEditor(context, true);
        },
        tooltip: 'Добавить ученика',
        child: Icon(Icons.add),
      ),
    );
  }

  //Open editor to add new student
  //Pass isEditing to allow editing for now
  _openStudentEditor(context, bool isEdit, {Student student}) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StudentEditor(
              isEditing: true,
              student: student,
            )));
    setState(() {});
  }

  void acceptAction(String title, String text, Function func) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Отменить',
                  style: theme.textTheme.body2,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Принять',
                  style: theme.textTheme.body2,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  func();
                },
              ),
            ],
          );
        });
  }
}
