import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

//Class that describes one lesson
//That could be convert to/from Json
class Lesson {
  int weekDay;
  DateTime lessonDate;
  Group groupToStudy;
  String theme;
  String homeWork;
  Decimal earnedMoney;
  TimeOfDay lessonTime;

  //All fields are required
  Lesson(
      {@required this.lessonDate,
      @required this.groupToStudy,
      @required this.theme,
      @required this.homeWork,
      @required this.lessonTime,
      @required this.earnedMoney})
      : weekDay = lessonDate.weekday;

  //Convert lesson object to Json data
  Map<String, dynamic> toJson() {
    return {
      'weekDay': weekDay,
      'lessonDate': lessonDate.toString(),
      'groupToStudy': groupToStudy?.groupId,
      'theme': theme,
      'lessonHour': lessonTime.hour,
      'lessonMin': lessonTime.minute,
      'homeWork': homeWork,
      'earnedMoney': earnedMoney.toString()
    };
  }

  //Create lesson object from Json data
  Lesson.fromJson(Map<String, dynamic> data)
      : lessonDate = DateTime.parse(data['lessonDate']),
        weekDay = data['weekDay'],
        groupToStudy =
            StudentsController.getInstance().getGroupById(data['groupToStudy']),
        theme = data['theme'],
        homeWork = data['homeWork'],
        lessonTime =
            TimeOfDay(hour: data['lessonHour'], minute: data['lessonMin']),
        earnedMoney = Decimal.parse(data['earnedMoney']);

  @override
  String toString() =>
      'Lesson: ${groupToStudy?.groupId}, ${lessonDate.toString()}, hw ${homeWork}, theme ${theme}, money ${earnedMoney}';

  //Update data
  void updateData(Decimal earnedMoney, Group group, String hw, TimeOfDay time,
      String studyTheme) {
    this.earnedMoney = earnedMoney;
    this.lessonTime = time;
    this.groupToStudy = group;
    this.homeWork = hw;
    this.theme = studyTheme;
  }
}
