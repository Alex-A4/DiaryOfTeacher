import 'dart:io';

import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:diary_of_teacher/src/models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class StudentEditor extends StatefulWidget {
  final bool isEditing;
  final Student student;

  StudentEditor({Key key, this.isEditing, this.student}) : super(key: key);

  _StudentEditorState createState() => _StudentEditorState(isEditing);
}

class _StudentEditorState extends State<StudentEditor> {
  StudentsController _controller = StudentsController.getInstance();

  _StudentEditorState(this._isEditing);

  TextStyle _hintStyle =
      TextStyle(fontSize: 18.0, letterSpacing: 1.0, color: Colors.grey[400]);

  bool _isEditing;

  bool _isLoading = false;

  PageStorageKey key = PageStorageKey('StudentKey');

  bool _isStudentExist = false;
  String photoUrl;
  String groupId;
  String groupName;
  TextEditingController _fioController;
  TextEditingController _characteristicController;
  DateTime _dateSince;

  DateTime _dateTo;

  final textTheme = TextStyle(
      fontFamily: 'Neucha',
      fontSize: 18.0,
      letterSpacing: 0.0,
      color: Colors.black);

  //Initializing all variables based on widget.student param
  @override
  void initState() {
    super.initState();
    photoUrl = widget.student?.photoUrl ?? Student.defaultPhotoUrl;

    _fioController = TextEditingController(text: widget.student?.fio ?? '');

    _characteristicController =
        TextEditingController(text: widget.student?.characteristic ?? '');

    _dateTo = widget.student?.studyingTo;

    _dateSince = widget.student?.studyingSince ?? DateTime.now().toUtc();

    groupName = widget.student?.groupId != null
        ? _controller.getGroupNameById(widget.student.groupId)
        : 'Укажите группу';
    groupId = widget.student?.groupId;

    if (widget.student != null) _isStudentExist = true;
  }

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
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    height: 120.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: AdvancedNetworkImage(photoUrl,
                                    useDiskCache: true,
                                    cacheRule:
                                        CacheRule(maxAge: Duration(days: 7))),
                                child: IconButton(
                                    iconSize: 30.0,
                                    color: Colors.white,
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: _isEditing
                                        ? () {
                                            pickAndUploadImage();
                                          }
                                        : null),
                                radius: 50.0,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.only(right: 8.0),
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
                                  decoration: InputDecoration(
                                      hintText: 'ФИО ученика',
                                      hintStyle: _hintStyle),
                                  style: textTheme,
                                ),
                              ),

                              //Group field
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Text(
                                      'Группа:',
                                      style: theme.textTheme.display4,
                                    ),
                                  ),
                                  PopupMenuButton<Group>(
                                    onSelected: (Group group) {
                                      setState(() {
                                        groupId = group.groupId;
                                      });
                                    },
                                    itemBuilder: (context) {
                                      return _controller.listOfGroups
                                          .map((group) {
                                        return PopupMenuItem<Group>(
                                          value: group,
                                          child: Text(group.name,
                                              style: theme.textTheme.display3),
                                        );
                                      }).toList();
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          _controller.getGroupNameById(groupId),
                                          style: theme.textTheme.display4,
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Date field
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Срок обучения:',
                          style: theme.textTheme.display4,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'С',
                              style: theme.textTheme.display4,
                            ),
                            FlatButton(
                              onPressed: _isEditing
                                  ? () async {
                                      _dateSince =
                                          await selectDate(context, _dateSince);
                                      setState(() {});
                                    }
                                  : null,
                              child: Text(
                                getStringDate(_dateSince),
                                style: theme.textTheme.display4,
                              ),
                            ),
                            Text(
                              'До ',
                              style: theme.textTheme.display4,
                            ),
                            GestureDetector(
                              child: _dateTo != null
                                  ? FlatButton(
                                      onPressed: _isEditing
                                          ? () async {
                                              _dateTo = await selectDate(
                                                  context, _dateTo);
                                              setState(() {});
                                            }
                                          : null,
                                      child: Text(
                                        getStringDate(_dateTo),
                                        style: theme.textTheme.display4,
                                      ),
                                    )
                                  : Text(
                                      'Ещё учится',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          letterSpacing: 0.0,
                                          color: Colors.black,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w900),
                                    ),
                              //Show dialog to choose still student studying or not
                              onLongPress: selectToDateStatus,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //Characteristic field
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    height: 300.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            maxLines: 50,
                            keyboardType: TextInputType.multiline,
                            enabled: _isEditing,
                            style: textTheme,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              hintStyle: _hintStyle,
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
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _isEditing ? saveStudent : startEdit,
        child: _isLoading
            ? CircularProgressIndicator()
            : Icon(_isEditing ? Icons.check : Icons.edit),
      ),
    );
  }

  //Update old or add new student to collection
  Future saveStudent() async {
    if (!validateStudent()) {
      Fluttertoast.showToast(
          msg: 'Дата начала обучения должна быть меньше даты окончания');
      return;
    }
    setState(() {
      _isLoading = true;
    });

    Student newStudent = Student(
        photoUrl: photoUrl,
        groupId: groupId,
        fio: _fioController.text,
        characteristic: _characteristicController.text,
        studyingTo: _dateTo,
        studyingSince: _dateSince);

    //Update or add student
    //If student of current session exist then update data otherwise add new
    if (_isStudentExist) {
      widget.student.updateData(newStudent);
    } else {
      _controller.addNewStudent(newStudent);
    }

    await _controller.saveDataToCache();

    _isStudentExist = true;

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    Fluttertoast.showToast(msg: 'Изменения сохранены');
  }

  //Start editing and update state
  void startEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  //Show dialog to choose the date
  Future<DateTime> selectDate(context, DateTime currentDate) async {
    var date = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(currentDate.year - 10, 1, 1),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 1));
    return date ?? currentDate;
  }

  //Simple validate of dates
  //Check is dateSince lowest then dateTo
  bool validateStudent() {
    if (_dateTo != null) if (_dateSince.compareTo(_dateTo) != -1) return false;

    return true;
  }

  //Convert date to comfortable string
  String getStringDate(DateTime date) {
    return '${date.day < 10 ? '0' : ''}${date.day}.${date.month < 10 ? '0' : ''}${date.month}.${date.year}';
  }

  //Show dialog and choose still student is studying
  Future selectToDateStatus() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 5.0,
            child: Container(
              color: theme.primaryColor,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Ученик ещё обучается?',
                    style: theme.textTheme.body1,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _dateTo = null;
                    },
                    child: Text(
                      'Да',
                      style: dialogButtonStyle,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _dateTo = DateTime.now();
                    },
                    child: Text(
                      'Нет',
                      style: dialogButtonStyle,
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          );
        });

    setState(() {});
  }

  //Ask user to pick image and then upload it to firebase
  Future pickAndUploadImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() => _isLoading = true);

      _controller.uploadImageAndGetUrl(imageFile).then((url) {
        photoUrl = url;
        Fluttertoast.showToast(msg: 'Фотографияи загружена');
        setState(() => _isLoading = false);
      }).catchError((error) {
        Fluttertoast.showToast(msg: error.toString());
        setState(() => _isLoading = false);
      });
    }
  }

  TextStyle dialogButtonStyle =
      TextStyle(fontSize: 23.0, color: theme.accentColor);
}
