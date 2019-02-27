import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:diary_of_teacher/src/models/student.dart';
import 'package:diary_of_teacher/src/ui/menu/students_subelements/StudentEditor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Screen that displays information about group
// and allow to change its name
class GroupEditor extends StatefulWidget {
  GroupEditor({Key key, @required this.group}) : super(key: key);

  final Group group;

  @override
  _GroupEditorState createState() => _GroupEditorState();
}

class _GroupEditorState extends State<GroupEditor> {
  StudentsController _controller = StudentsController.getInstance();

  bool _isLoading = false;
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Группа ${widget.group.name}'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.topCenter,
            padding: const EdgeInsets.only(
                top: 16.0, left: 24.0, right: 24.0),
            height: 70.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Название группы',
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                        ),
                        maxLength: 20,
                        controller: _nameController,
                        style: theme.textTheme.body2,
                      ),
                      fit: FlexFit.loose,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : IconButton(
                            onPressed: updateName,
                            icon: Icon(Icons.update, color: theme.accentColor,),
                          ),
                  ],
                ),

                Divider(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 100.0),
            child: ListView(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              children: widget.group.students
                  .map((stud) => getStudentElement(stud))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  //Update name asynchronously and show toast
  void updateName() {
    widget.group.updateName(_nameController.text);
    setState(() => _isLoading = true);
    _controller.saveDataToCache().then((_) {
      Fluttertoast.showToast(msg: 'Название успешно изменено');
      setState(() => _isLoading = false);
    }).catchError((error) {
      Fluttertoast.showToast(msg: error);
      setState(() => _isLoading = false);
    });
  }

  //Get student representation
  Widget getStudentElement(Student stud) {
    return ListTile(
      title: Text(
        stud.fio,
        style: theme.textTheme.display4,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_sweep),
        onPressed: () {
          removeStudent(stud);
        },
        tooltip: 'Удалить ученика из группы',
      ),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StudentEditor(
                  student: stud,
                  isEditing: true,
                )));
        setState(() {});
      },
    );
  }

  //Remove student from group and save result to cache
  void removeStudent(Student stud) {
    widget.group.removeStudentFromGroup(stud);

    _controller.saveDataToCache().then((_) {
      Fluttertoast.showToast(msg: 'Ученик удален из группы');
      setState(() => _isLoading = false);
    }).catchError((error) {
      Fluttertoast.showToast(msg: error);
      setState(() => _isLoading = false);
    });
  }
}
