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
  List<String> imagesList;

  //All fields are required
  Lesson(
      {@required this.lessonDate,
      @required this.groupToStudy,
      @required this.theme,
      @required this.homeWork,
      @required this.lessonTime,
      @required this.earnedMoney,
      this.imagesList})
      : weekDay = lessonDate.weekday {
    if (imagesList.isEmpty) imagesList = [];
  }

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
      'imagesList': imagesList,
      'earnedMoney': earnedMoney.toString()
    };
  }

  //Create lesson object from Json data
  Lesson.fromJson(Map<dynamic, dynamic> data)
      : lessonDate = DateTime.parse(data['lessonDate']),
        weekDay = data['weekDay'],
        groupToStudy =
            StudentsController.getInstance().getGroupById(data['groupToStudy']),
        theme = data['theme'],
        homeWork = data['homeWork'],
        lessonTime =
            TimeOfDay(hour: data['lessonHour'], minute: data['lessonMin']),
        earnedMoney = Decimal.parse(data['earnedMoney']),
        imagesList = data['imagesList'];

  @override
  String toString() =>
      'Lesson: ${groupToStudy?.groupId}, ${lessonDate.toString()}, hw ${homeWork},'
      ' theme ${theme}, money ${earnedMoney}, images: ${imagesList.toString()}';

  //Update data
  void updateData(Decimal earnedMoney, Group group, String hw, TimeOfDay time,
      String studyTheme, List<String> images) {
    this.earnedMoney = earnedMoney;
    this.lessonTime = time;
    this.groupToStudy = group;
    this.imagesList = images;
    this.homeWork = hw;
    this.theme = studyTheme;
  }
}
