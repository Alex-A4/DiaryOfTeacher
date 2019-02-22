import 'package:diary_of_teacher/src/models/group.dart';
import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';

//Class that describes one lesson
class Lesson {
  DateTime lessonTime;
  Group groupToStudy;
  String theme;
  String homeWork;
  Decimal earnedMoney;

  Lesson(
      {@required this.lessonTime,
      @required this.groupToStudy,
      @required this.theme,
      @required this.homeWork,
      @required this.earnedMoney});


  //Convert lesson object to Json data
  Map<String, dynamic> toJson() {
    return {
      'lessonTime': lessonTime.toString(),
      'groupToStudy': groupToStudy.groupId,
      'theme': theme,
      'homeWork': homeWork,
      'earnedMoney': earnedMoney.toString()
    };
  }

  //Create lesson object from Json data
  Lesson.fromJson(Map<String, dynamic> data)
      : lessonTime = data['lessonTime'],
        groupToStudy = data['groupToStudy'],
        theme = data['theme'],
        homeWork = data['homeWork'],
        earnedMoney = data['earnedMoney'];
}
