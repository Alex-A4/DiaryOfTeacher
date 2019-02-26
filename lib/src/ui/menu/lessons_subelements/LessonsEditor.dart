import 'package:decimal/decimal.dart';
import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/lesson_controller.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:diary_of_teacher/src/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class LessonsEditor extends StatefulWidget {
  LessonsEditor({Key key, @required this.lesson}) : super(key: key);

  Lesson lesson;

  @override
  _LessonsEditorState createState() => _LessonsEditorState();
}

class _LessonsEditorState extends State<LessonsEditor> {
  Lesson get lesson => widget.lesson;
  LessonController _lessonController = LessonController.getInstance();
  StudentsController _studentsController = StudentsController.getInstance();

  Decimal earnedMoney;
  String groupId;
  String studyTheme;
  String hw;
  DateTime lessonTime;

  TextEditingController _moneyController;
  TextEditingController _themeController;
  TextEditingController _hwController;

  @override
  void initState() {
    super.initState();
    earnedMoney = lesson?.earnedMoney ?? Decimal.fromInt(0);
    groupId = lesson?.groupToStudy?.groupId ?? '';
    studyTheme = lesson?.theme ?? '';
    hw = lesson?.homeWork ?? '';
    lessonTime = lesson?.lessonTime;

    _moneyController = TextEditingController(text: earnedMoney.toString());
    _themeController = TextEditingController(text: studyTheme);
    _hwController = TextEditingController(text: hw);
  }

  @override
  void dispose() {
    _moneyController.dispose();
    _themeController.dispose();
    _hwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактор уроков'),
      ),
      body: Container(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        children: <Widget>[
          //Lesson date
          GestureDetector(
            child: Text(
              getDateToShow() ?? 'Укажите дату',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                letterSpacing: 0.0,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () {
              getDateAndTime();
            },
          ),

          SizedBox(
            height: 16.0,
          ),

          //Lesson group
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Группа:',
                    style: theme.textTheme.display4,
                  )),
              PopupMenuButton<Group>(
                onSelected: (Group group) {
                  setState(() {
                    groupId = group.groupId;
                  });
                },
                itemBuilder: (context) {
                  return _studentsController.listOfGroups.map((group) {
                    return PopupMenuItem<Group>(
                      value: group,
                      child: Text(group.name, style: theme.textTheme.display3),
                    );
                  }).toList();
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      _studentsController.getGroupNameById(groupId),
                      style: theme.textTheme.display4,
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: 16.0,
          ),

          //Theme field
          Container(
            child: TextField(
              controller: _themeController,
              decoration: InputDecoration(
                hintText: 'Тема занятия',
                hintStyle: hintStyle,
              ),
            ),
          ),

          SizedBox(
            height: 16.0,
          ),

          //Money field
          Container(
            padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Доход:',
                  style: theme.textTheme.display4,
                ),
                Container(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  width: 120.0,
                  child: TextField(
                    decoration: InputDecoration(
                        hintStyle: hintStyle,
                        hintText: '0',
                        suffixText: 'руб.',
                        suffixStyle: TextStyle(color: Colors.black, fontSize: 15.0),
                        contentPadding: const EdgeInsets.only(bottom: 0.0)),
                    controller: _moneyController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 16.0,
          ),

          //Homework field
          Container(
            height: 150.0,
            child: TextField(
              controller: _hwController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                hintText: 'Домашнее задание',
                hintStyle: hintStyle,
              ),
              maxLines: 30,
            ),
          ),

          //TODO: add list of images which could be downloaded with ImagePicker
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: saveLesson,
        child: Icon(Icons.save_alt),
        tooltip: 'Сохранить данные',
      ),
    );
  }

  //Get formatted string to show date like dd.mm.yyy,  hh:mm
  String getDateToShow() {
    if (lessonTime == null) return null;

    return '${lessonTime.day}.${lessonTime.month}.${lessonTime.year},  ${lessonTime.hour}:${lessonTime.minute}';
  }

  //Show dialog to pick date and time
  Future getDateAndTime() async {
    //Get user date
    DatePicker.showDateTimePicker(context,
        currentTime: lessonTime ?? DateTime.now(),
        locale: LocaleType.ru,
        showTitleActions: true,
        theme: DatePickerTheme(
            doneStyle:
                TextStyle(color: theme.primaryColorDark, fontSize: 17.0)),
        onConfirm: (date) {
      lessonTime = date;
      setState(() {});
    });
  }

  //Save lesson to local cache:
  // Firstly update data at lesson or create new
  // Secondly save data
  void saveLesson() {
    updateValues();

    if (lessonTime == null) {
      Fluttertoast.showToast(msg: 'Не указана дата');
      return;
    }

    if (lesson == null) {
      widget.lesson = Lesson(
          earnedMoney: earnedMoney,
          groupToStudy: _studentsController.getGroupById(groupId),
          homeWork: hw,
          lessonTime: lessonTime,
          theme: studyTheme);
    } else
      lesson.updateData(earnedMoney, _studentsController.getGroupById(groupId),
          hw, lessonTime, studyTheme);

    print(lesson);

    _lessonController.addLessonForDate(lesson.lessonTime, lesson);
    _lessonController.saveToCache().then((_) {
      Fluttertoast.showToast(msg: 'Сохранение успешно');
    }).catchError((_) {
      Fluttertoast.showToast(msg: 'Ошибка сохранения');
    });
  }

  //Update values of variables before saving it
  //  groupId updates when group selected
  //  lessonTime updates when user pick DateTime
  void updateValues() {
    earnedMoney = Decimal.parse(
        _moneyController.text.isEmpty ? '0' : _moneyController.text);
    hw = _hwController.text;
    studyTheme = _themeController.text;
  }

  TextStyle hintStyle =
      TextStyle(fontSize: 15.0, color: Colors.black26, letterSpacing: 1.0);
}
