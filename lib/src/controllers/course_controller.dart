import 'dart:convert';
import 'dart:io';
import 'package:diary_of_teacher/src/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../mixins/network_mixin.dart';

//Singleton object which store information about all courses
class CourseController extends ImageUploader {
  static final JsonCodec _codec = JsonCodec();

  //Singleton instance of object
  static CourseController _controller;

  //List of courses
  List<Course> _courses;

  //Default private constructor
  CourseController._();

  static CourseController getInstance() => _controller;

  //Build controller by restoring all data
  static Future buildController() async {
    if (_controller == null) {
      _controller = CourseController._();
      await _controller.restoreFromCache();
    }
  }

  //Restore data from local storage
  Future restoreFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String line = prefs.getString('courses');
    if (line != null) {
      List<dynamic> dynCourses = _codec.decode(line);
      _courses = dynCourses.map((data) => Course.fromJson(data)).toList();
    } else
      _courses = [];
  }

  //Saving all courses to cache
  Future saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('courses', _codec.encode(_courses));
  }

  //Upload image to cloud firebase
  Future<String> uploadImageAndGetUrl(File image) async {
    String url =
        await uploadImage(image, Uuid().v1()).catchError((err) => throw err);

    return url;
  }
}
