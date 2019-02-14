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
  StudentsController _controller = StudentsController.getInstance();
  bool _isEditing;
  bool _isLoading = false;
  PageStorageKey key = PageStorageKey('StudentKey');

  bool _isStudentExist = false;

  String photoUrl;
  String groupId;
  String groupName;
  TextEditingController _fioController;
  TextEditingController _courseController;
  TextEditingController _characteristicController;
  DateTime _dateSince;
  DateTime _dateTo;

  final textTheme =
      TextStyle(color: Colors.black, fontSize: 15.0, letterSpacing: 0.0);

  //Initializing all variables based on widget.student param
  @override
  void initState() {
    super.initState();
    photoUrl = widget.student?.photoUrl ?? Student.defaultPhotoUrl;

    _fioController = TextEditingController(text: widget.student?.fio ?? '');

    _courseController =
        TextEditingController(text: widget.student?.course ?? '');

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
                                backgroundImage:
                                    CachedNetworkImageProvider(photoUrl),
                                child: IconButton(
                                    iconSize: 30.0,
                                    color: Colors.white,
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: _isEditing ? () {} : null),
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
                                  decoration:
                                      InputDecoration(hintText: 'ФИО ученика'),
                                  style: textTheme,
                                ),
                              ),

                              //Group field
                              //TODO: add pop-up menu to select group
                              Text(
                                groupName,
                                softWrap: true,
                                style: theme.textTheme.display3,
                              ),

                              //Course field
                              Expanded(
                                child: TextField(
                                  enabled: _isEditing,
                                  decoration: InputDecoration(
                                      hintText: 'Название курса'),
                                  controller: _courseController,
                                  style: textTheme,
                                ),
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
                                softWrap: true,
                                style: theme.textTheme.display4,
                              ),
                            ),
                            Text(
                              'До',
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
                                        softWrap: true,
                                        style: theme.textTheme.display4,
                                      ),
                                    )
                                  : Text(
                                      'Учится..',
                                      style: theme.textTheme.display4,
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
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
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
        course: _courseController.text,
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
  bool validateStudent() {
    if (_dateSince.compareTo(_dateTo) != -1) return false;
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Ученик ещё обучается?', style: theme.textTheme.body1,),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _dateTo = null;
                  },
                  child: Text(
                    'Да',
                    style: theme.textTheme.body1,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _dateTo = DateTime.now();
                  },
                  child: Text(
                    'Нет',
                    style: theme.textTheme.body1,
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          );
        });

    setState(() {});
  }
}
