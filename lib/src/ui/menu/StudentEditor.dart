import 'package:diary_of_teacher/src/models/student.dart';
import 'package:flutter/material.dart';


class StudentEditor extends StatefulWidget {
 final bool isEditing;
 final Student student;

 StudentEditor({Key key, this.isEditing, this.student}):super(key: key);

 _StudentEditorState createState() => _StudentEditorState(isEditing);
}

class _StudentEditorState extends State<StudentEditor> {
  bool _isEditing;
  bool isLoading = false;
  PageStorageKey key = PageStorageKey('StudentKey');

  _StudentEditorState(this._isEditing);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактор студентов'),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ListView(
            key: key,
          ),

          isLoading ? Center(child: CircularProgressIndicator(),) : Container(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(_isEditing ? Icons.check : Icons.edit),
      ),
    );
  }
}