import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/lesson_controller.dart';
import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:diary_of_teacher/src/models/lesson.dart';
import 'package:diary_of_teacher/src/ui/menu/lessons_subelements/photo_card.dart';
import 'package:diary_of_teacher/src/ui/menu/students_subelements/GroupEditor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';

class LessonsEditor extends StatefulWidget {
  LessonsEditor({Key key, @required this.date, @required this.lesson})
      : super(key: key);

  DateTime date;
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
  TimeOfDay lessonTime;
  List<String> imagesList;

  TextEditingController _moneyController;
  TextEditingController _themeController;
  TextEditingController _hwController;

  //Initialize all variables by default values or incoming
  @override
  void initState() {
    super.initState();
    earnedMoney = lesson?.earnedMoney ?? Decimal.fromInt(0);
    groupId = lesson?.groupToStudy?.groupId;
    studyTheme = lesson?.theme ?? '';
    hw = lesson?.homeWork ?? '';
    lessonTime = lesson?.lessonTime;
    imagesList = lesson?.imagesList ?? [];

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
      body: ListView(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              children: <Widget>[
                //Theme field
                Container(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: TextField(
                    controller: _themeController,
                    decoration: InputDecoration(
                      hintText: 'Тема занятия',
                      hintStyle: hintStyle,
                    ),
                  ),
                ),

                Container(
                  height: 100.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Lesson date
                      GestureDetector(
                        child: Text(
                          getDateToShow() ?? 'Укажите время занятия',
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
                              return _studentsController.listOfGroups
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
                                  _studentsController.getGroupNameById(groupId),
                                  style: theme.textTheme.display4,
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.only(left: 50.0),
                            alignment: AlignmentDirectional.centerEnd,
                            icon: Icon(
                              groupId == null
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: theme.accentColor,
                            ),
                            tooltip: 'Посмотреть группу',
                            onPressed: groupId == null
                                ? null
                                : () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => GroupEditor(
                                                  group: StudentsController
                                                          .getInstance()
                                                      .getGroupById(groupId),
                                                )));
                                  },
                          ),
                        ],
                      ),

                      //Money field
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Доход:',
                              style: theme.textTheme.display4,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  right: 16.0, left: 16.0),
                              width: 120.0,
                              child: TextField(
                                decoration: InputDecoration(
                                    hintStyle: hintStyle,
                                    hintText: '0',
                                    suffixText: 'руб.',
                                    suffixStyle: TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0.0)),
                                controller: _moneyController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //Homework field
                Container(
                  padding: const EdgeInsets.only(top: 32.0),
                  height: 150.0,
                  child: TextField(
                    controller: _hwController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      fillColor: theme.accentColor,
                      hintText: 'Домашнее задание',
                      hintStyle: hintStyle,
                    ),
                    maxLines: 30,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 80,
          ),

          Divider(),
          //TODO: add Hero animation
          Container(
            height: 150.0,
            child: imagesList.isEmpty
                ? Container(
                    child: Center(
                      child: Text(
                        'Список фотографий пуст',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Neucha',
                            fontSize: 25.0),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: imagesList.length,
                    itemBuilder: (context, index) => PhotoCard(
                          photoUrl: imagesList[index],
                          deleteFunc: () {
                            imagesList.remove(imagesList[index]);
                            setState(() {});
                          },
                        ),
                    scrollDirection: Axis.horizontal,
                  ),
          ),
          Divider(),

          Container(
            child: Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  selectImageAndSave();
                },
                color: theme.accentColor,
                child: Text(
                  'Загрузить',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'RobotoCondensed',
                      color: Colors.white),
                ),
                elevation: 5.0,
              ),
            ),
          ),

          SizedBox(
            height: 80.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveLesson,
        child: Icon(Icons.check),
        tooltip: 'Сохранить данные',
      ),
    );
  }

  //Get formatted string to show date like dd.mm.yyy,  hh:mm
  String getDateToShow() {
    if (lessonTime == null) return null;

    String dayZero = '';
    String monthZero = '';
    String minuteZero = '';
    if (widget.date.day < 10) dayZero = '0';
    if (widget.date.month < 10) monthZero = '0';
    if (lessonTime.minute < 10) minuteZero = '0';

    return '$dayZero${widget.date.day}.$monthZero${widget.date.month}.${widget.date.year},'
        '  ${lessonTime.hour}:$minuteZero${lessonTime.minute}';
  }

  //Show dialog to pick date and time
  void getDateAndTime() {
    //Get user date
    DatePicker.showTimePicker(context,
        currentTime: lessonTime ?? DateTime.now(),
        locale: LocaleType.ru,
        showTitleActions: true,
        theme: DatePickerTheme(
            doneStyle:
                TextStyle(color: theme.primaryColorDark, fontSize: 17.0)),
        onConfirm: (time) {
      lessonTime = TimeOfDay(hour: time.hour, minute: time.minute);
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

    //If lesson not exist, then create it and add to events
    if (lesson == null) {
      widget.lesson = Lesson(
          lessonDate: widget.date,
          earnedMoney: earnedMoney,
          groupToStudy: _studentsController.getGroupById(groupId),
          homeWork: hw,
          lessonTime: lessonTime,
          theme: studyTheme,
          imagesList: imagesList);

      _lessonController.addLessonForDate(widget.date, lesson);
    } else
      lesson.updateData(earnedMoney, _studentsController.getGroupById(groupId),
          hw, lessonTime, studyTheme, imagesList);

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

  //Select image by picker, save to cache and update screen
  Future selectImageAndSave() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    await _lessonController.addImageAndSave(image).then((url) {
      imagesList.add(url);
      setState(() {});
    }).catchError((error) {
      Fluttertoast.showToast(msg: error);
    });
  }
}
