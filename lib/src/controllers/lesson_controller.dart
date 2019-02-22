import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson.dart';


//Singleton controller of lessons
//It can save/restore data to/from cache.
//Contains all information about lessons
class LessonController {
  static LessonController _controller;

  //Json decoder to convert to/from Json
  static JsonCodec _decoder = JsonCodec();

  //Events that need for calendar
  Map<DateTime, List<Lesson>> _events = {};

  Map<DateTime, List<Lesson>> get events => _events;


  static LessonController getInstance() {
    return _controller;
  }

  //Build controller and read data from cache
  //WARNING: controller must be build before getInstance call
  static Future buildController() async {
    _controller = LessonController._();
    _controller._fromCache();
  }

  //Private constructor to block local instances
  LessonController._();


  //Add lesson to specified date
  void addLessonForDate(DateTime date, Lesson lesson) {
    if (!_events.containsKey(lesson.lessonTime)) {
      _events[lesson.lessonTime] = [lesson];
      return;
    }

    _events.keys.forEach((eventDate) {
      if (isDatesEquals(eventDate, date)) {
        _events[eventDate].add(lesson);
        lesson.lessonTime = eventDate;
        return;
      }
    });
  }

  //Checks is dates equals to the minutes
  bool isDatesEquals(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute;
  }


  //Restore events from local cache
  Future _fromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringEvents = prefs.getString('events');
    if (stringEvents == null)
      return;

    List<dynamic> listOfEvents = _decoder.decode(stringEvents);

    print('EVENTS: $listOfEvents');

    listOfEvents.forEach((listOfLessons) {
      List<Lesson> newLessons = [];
      listOfLessons.forEach((lesson) {
        Lesson.fromJson(lesson);
        newLessons.add(lesson);
      });

      if (newLessons.length != 0)
        _events[newLessons[0].lessonTime] = newLessons;
    });
  }

  //Save lessons to local cache
  //All entries looks like: List of  lesson lists [[lessons1],[lessons2]...]
  Future saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('events', _decoder.encode(convertEventsToJson()));
    print('Lessons saved to cache!');
  }

  //Convert events to dynamic list to save to cache
  List<dynamic> convertEventsToJson() {
    List<dynamic> dyn = [];
    events.values.forEach((list) {
      dyn.add(convertLessonsListToJson(list));
    });
    return dyn;
  }

  //Convert list of lessons to Json list
  List<dynamic> convertLessonsListToJson(List<Lesson> lessons) {
    List<dynamic> dyn = [];
    lessons.forEach((lesson) => dyn.add(lesson.toJson()));
    return dyn;
  }
}
