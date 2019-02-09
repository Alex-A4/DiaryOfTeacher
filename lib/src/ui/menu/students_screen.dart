import 'package:cached_network_image/cached_network_image.dart';
import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/student.dart';
import 'package:diary_of_teacher/src/ui/menu/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentsScreen extends StatefulWidget {
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<StudentsScreen> {
  StudentsController _controller = StudentsController.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ученики'),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              _controller.saveDataToFirebase().then((_){
                Fluttertoast.showToast(msg: 'Данные сохранены');
              }).catchError((error){
                Fluttertoast.showToast(msg: error);
              });
            },
            icon: Icon(Icons.save_alt),
            tooltip: 'Сохранить на диск',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _controller.listOfStudents.length,
        itemBuilder: (context, index) {
          Student student = _controller.listOfStudents[index];

          return ListTile(
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
                  icon: Icon(Icons.archive),
                  onPressed: () {
                    print('ArchivePressed');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print('Deleted pressed');
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
          print('ADD FAB');
        },
        tooltip: 'Добавить ученика',
        child: Icon(Icons.add),
      ),
    );
  }
}
