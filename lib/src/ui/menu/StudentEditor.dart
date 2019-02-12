import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/student.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentEditor extends StatefulWidget {
  final bool isEditing;
  final Student student;

  StudentEditor({Key key, this.isEditing, this.student}) : super(key: key);

  _StudentEditorState createState() => _StudentEditorState(isEditing);
}

class _StudentEditorState extends State<StudentEditor> {
  StudentsController _repository = StudentsController.getInstance();
  bool _isEditing;
  bool _isLoading = false;

  String photoUrl;
  String groupName;
  PageStorageKey key = PageStorageKey('StudentKey');
  TextEditingController _fioController;
  TextEditingController _courseController;
  TextEditingController _characteristicController;
  DateTime _dateSince;
  DateTime _dateTo;

  @override
  void initState() {
    super.initState();
    photoUrl = widget.student?.photoUrl ?? Student.defaultPhotoUrl;
    _fioController = TextEditingController(text: widget.student?.fio ?? '');
    _courseController =
        TextEditingController(text: widget.student?.course ?? '');
    _characteristicController =
        TextEditingController(text: widget.student?.characteristic ?? '');
    _dateTo = widget.student?.studyingTo ?? DateTime.now().toUtc();
    _dateSince = widget.student?.studyingSince ?? DateTime.now().toUtc();
    groupName = widget.student?.groupId != null
        ? _repository.getGroupNameById(widget.student.groupId)
        : 'Группа указывается в специальном разделе';
  }

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
          CustomScrollView(
            key: key,
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate(
                <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    height: 200.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(photoUrl),
                              child: IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: _isEditing ? () {} : null),
                              radius: 50.0,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //FIO field
                            Expanded(
                              child: TextField(
                                enabled: _isEditing,
                                controller: _fioController,
                                decoration: InputDecoration(hintText: 'ФИО ученика'),
                                style: theme.textTheme.body1,
                              ),
                            ),
                              //Group field
                              Text(
                                groupName,
                                softWrap: true,
                                style: theme.textTheme.display3,
                              ),
                              //Date field
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'С  ',
                                    style: theme.textTheme.display4,
                                  ),
                                  GestureDetector(
                                    onTap: _isEditing
                                        ? () {
                                      print('DateSince Pressed');
                                    }
                                        : null,
                                    child: Text(
                                      _dateSince.toLocal().toString(),
                                      softWrap: true,
                                      style: theme.textTheme.display4,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'До  ',
                                    style: theme.textTheme.display4,
                                  ),
                                  GestureDetector(
                                    onTap: _isEditing
                                        ? () {
                                      print('DateTo Pressed');
                                    }
                                        : null,
                                    child: Text(
                                      _dateTo.toLocal().toString(),
                                      softWrap: true,
                                      style: theme.textTheme.display4,
                                    ),
                                  ),
                                ],
                              ),

                              //Course field
                            Expanded(
                              child: TextField(
                                enabled: _isEditing,
                                decoration:
                                InputDecoration(hintText: 'Название курса'),
                                controller: _courseController,
                                style: theme.textTheme.body1,
                              ),
                            ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Characteristic field
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    height: 200.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            enabled: _isEditing,
                            style: theme.textTheme.body1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              hintStyle: TextStyle(fontSize: 17.0),
                              hintText: 'Характеристика ученика',
                            ),
                            scrollPadding: EdgeInsets.symmetric(vertical: 5.0),
                            controller: _characteristicController,
                          ),
                          fit: FlexFit.tight,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isEditing ? saveStudent : startEdit,
        child: Icon(_isEditing ? Icons.check : Icons.edit),
      ),
    );
  }

  //Update old or add new student to collection
  Future saveStudent() async {
    print('SAVING STARTED');
    setState(() {
      _isLoading = true;
    });

    Student newStudent = Student(
        photoUrl: photoUrl,
        groupId: widget.student?.groupId,
        fio: _fioController.text,
        course: _courseController.text,
        characteristic: _characteristicController.text,
        studyingTo: _dateTo,
        studyingSince: _dateSince);

    //Update or add student
    if (widget.student != null) {
      widget.student.updateData(newStudent);
    } else {
      _repository.addNewStudent(newStudent);
    }

    await _repository.saveDataToCache();

    setState(() {
      _isLoading = false;
    });

    Fluttertoast.showToast(msg: 'Изменения сохранены');
    print('SAVING FINISHED');
  }

  void startEdit() {
    setState(() {
      _isEditing = true;
    });
  }
}
