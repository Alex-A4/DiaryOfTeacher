import 'package:decimal/decimal.dart';
import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/lesson_controller.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:diary_of_teacher/src/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  @override
  void initState() {
    super.initState();
    earnedMoney = lesson?.earnedMoney ?? Decimal.fromInt(0);
    groupId = lesson?.groupToStudy?.groupId ?? '';
    studyTheme = lesson?.theme ?? '';
    hw = lesson?.homeWork ?? '';
    lessonTime = lesson?.lessonTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактор уроков'),
      ),
      body: Container(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

          SizedBox(
            height: 16.0,
          ),

          //Theme field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(),
          ),

          SizedBox(
            height: 16.0,
          ),

          //Money field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Text('Доход:'),
                Container(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  width: 100.0,
                  child: TextField(
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Text('руб.'),
              ],
            ),
          ),

          SizedBox(
            height: 16.0,
          ),

          //Homework field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(),
          ),
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

  //Show two dialogs:
  // First to pick date of lesson
  // Second to pick time of lesson
  Future getDateAndTime() async {
    print('GetDateAndTime');
  }

  //Save lesson to local cache:
  // Firstly update data at lesson or create new
  // Secondly save data
  void saveLesson() {
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

    if (lesson.lessonTime == null) {
      Fluttertoast.showToast(msg: 'Не указана дата');
      return;
    }
    _lessonController.addLessonForDate(lesson.lessonTime, lesson);
    _lessonController.saveToCache().then((_) {
      Fluttertoast.showToast(msg: 'Сохранение успешно');
    }).catchError((_) {
      Fluttertoast.showToast(msg: 'Ошибка сохранения');
    });
  }
}
