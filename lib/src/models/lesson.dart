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

}
