import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:diary_of_teacher/src/models/user.dart';
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

  //Add lesson to events by specified date
  // Date of lesson could not be changed. User can change only time
  void addLessonForDate(DateTime date, Lesson lesson) {
    if (date == null || lesson == null)
      throw 'Trying to add null value to list';

    //Add lesson and date if it was not exist before
    if (!isEventsContainsDate(date)) {
      _events[date] = [lesson];
      return;
    }

    //Add lesson to date if it was exist
    _events.keys.forEach((eventDate) {
      if (isDatesEquals(eventDate, date)) {
        _events[eventDate].add(lesson);
        return;
      }
    });
  }

  //Remove lesson from specified date
  //If list of lessons at date is empty then remove date
  void removeLessonFromDate(DateTime date, Lesson lesson) {
    if (date == null || lesson == null)
      throw 'Trying to remove null value from list';

    //If there is no date in list
    if (!isEventsContainsDate(date)) return;

    var listEvents = events.keys.toList();
    for (int i = 0; i < listEvents.length; i++) {
      var eventDate = listEvents[i];
      if (isDatesEquals(eventDate, date)) {
        //Delete lesson at date
        _events[eventDate].remove(lesson);

        //Delete date if lessons empty
        if (_events[eventDate].length < 1) _events.remove(eventDate);

        return;
      }
    }
  }

  //Custom check is events map contains [date]
  bool isEventsContainsDate(DateTime date) {
    bool isContains = false;
    events.keys.forEach((d) {
      if (isDatesEquals(date, d)) {
        isContains = true;
        return;
      }
    });

    return isContains;
  }

  //Checks is dates equals to day
  bool isDatesEquals(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  //Restore events from local cache
  Future _fromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringEvents = prefs.getString('events');
    if (stringEvents == null) return;

    List<dynamic> listOfEvents = _decoder.decode(stringEvents);

    listOfEvents.forEach((listOfLessons) {
      List<Lesson> newLessons = [];
      listOfLessons.forEach((lesson) {
        newLessons.add(Lesson.fromJson(lesson));
      });

      if (newLessons.length != 0)
        _events[newLessons[0].lessonDate] = newLessons;
    });
  }

  //Save lessons to local cache
  //All entries looks like: List of  lesson lists [[lessons1],[lessons2]...]
  Future saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'events', _decoder.encode(convertEventsToJsonLikeList()));
    print('Lessons saved to cache!');
  }

  //Save all lessons to cloud firestore
  Future saveToFirestore() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';

    await Firestore.instance
        .collection('users')
        .document(User.user.uid)
        .collection('lessons')
        .document('events')
        .setData({'events': convertEventsToJsonLikeMap()});
    print('Lessons saved to cache');
  }

  //Convert events to dynamic list to save to cache
  List<dynamic> convertEventsToJsonLikeList() {
    List<dynamic> dyn = [];
    events.values.forEach((list) {
      dyn.add(convertLessonsListToJson(list));
    });
    return dyn;
  }

  //Convert events to dynamic map to save to firestore
  // Firestore do not allow inherited dynamic lists
  Map<String, dynamic> convertEventsToJsonLikeMap() {
    Map<String, dynamic> map = {};
    events.forEach((date, lessons) {
      map[date.toString()] = convertLessonsListToJson(lessons);
    });

    return map;
  }

  //Convert list of lessons to Json list
  List<dynamic> convertLessonsListToJson(List<Lesson> lessons) {
    List<dynamic> dyn = [];
    lessons.forEach((lesson) => dyn.add(lesson.toJson()));
    return dyn;
  }


  //Restore all data from cloud firestore
  // WARNING: all existing data will be rewritten
  Future restoreLessonsFromFirestore() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';

    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(User.user.uid)
        .collection('lessons')
        .document('events')
        .get();

    if (snapshot == null) throw 'В облаке нет данных';

    var dynamicData = snapshot['events'];

    _events.clear();

    //Build lessons from dynamic data
    dynamicData.forEach((date, lessonsList) {
      if (lessonsList.length > 0) {
        List<Lesson> newLessons = [];

        lessonsList.forEach((lesson) {
          newLessons.add(Lesson.fromJson(lesson));
        });

        _events[DateTime.parse(date)] = newLessons;
      }
    });

    await saveToCache();
  }
}
