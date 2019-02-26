import 'package:diary_of_teacher/src/controllers/students_controller.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';

//Class that describes one lesson
//That could be convert to/from Json
class Lesson {
  int weekDay;
  DateTime lessonTime;
  Group groupToStudy;
  String theme;
  String homeWork;
  Decimal earnedMoney;

  //All fields are required
  Lesson(
      {@required this.lessonTime,
      @required this.groupToStudy,
      @required this.theme,
      @required this.homeWork,
      @required this.earnedMoney})
      : weekDay = lessonTime.weekday;

  //Convert lesson object to Json data
  Map<String, dynamic> toJson() {
    return {
      'weekDay': weekDay,
      'lessonTime': lessonTime.toString(),
      'groupToStudy': groupToStudy?.groupId,
      'theme': theme,
      'homeWork': homeWork,
      'earnedMoney': earnedMoney.toString()
    };
  }

  //Create lesson object from Json data
  Lesson.fromJson(Map<String, dynamic> data)
      : lessonTime = DateTime.parse(data['lessonTime']),
        weekDay = data['weekDay'],
        groupToStudy = StudentsController.getInstance().getGroupById(data['groupToStudy']),
        theme = data['theme'],
        homeWork = data['homeWork'],
        earnedMoney = Decimal.parse(data['earnedMoney']);

  @override
  String toString() =>
      'Lesson: ${groupToStudy.groupId}, ${lessonTime.toString()}, hw ${homeWork}, theme ${theme}, money ${earnedMoney}';

  //Update data
  void updateData(Decimal earnedMoney, Group group, String hw,
      DateTime lessonTime, String studyTheme) {
    this.earnedMoney = earnedMoney;
    this.lessonTime = lessonTime;
    this.groupToStudy = group;
    this.homeWork = hw;
    this.theme = studyTheme;
  }
}
