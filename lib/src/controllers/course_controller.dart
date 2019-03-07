import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_of_teacher/src/models/course.dart';
import 'package:diary_of_teacher/src/models/user.dart';
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
      _courses = convertJsonToCourses(_codec.decode(line));
    } else
      _courses = [];
  }

  //Saving all courses to cache
  Future saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('courses', _codec.encode(convertListToJson()));
  }

  //Upload image to cloud firebase
  Future<String> uploadImageAndGetUrl(File image) async {
    String url =
        await uploadImage(image, Uuid().v1()).catchError((err) => throw err);

    return url;
  }

  //Uploading data about courses to cloud firestore
  Future uploadDataToFirestore() async {
    if (!await isConnected()) throw 'Отсутствует интернет соединение';

    await Firestore.instance
        .collection('users')
        .document(User.user.uid)
        .collection('courses')
        .document('courses')
        .updateData({'courses': convertListToJson()});
  }

  //Restore data about courses from the cloud firestore
  Future restoreDataFromFirestore() async {
    if (!await isConnected()) throw 'Отсутствует интернет соединение';

    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(User.user.uid)
        .collection('courses')
        .document('courses')
        .get();

    if (snapshot == null) throw 'Нет данных в облаке';
    _courses = convertJsonToCourses(snapshot.data['courses']);

    await saveToCache();
  }

  //Convert list of courses to dynamic list
  List<Map<String, dynamic>> convertListToJson() =>
      _courses.map((data) => data.toJson()).toList();

  //Convert dynamic list to list of courses
  List<Course> convertJsonToCourses(List<dynamic> dynCourses) =>
      dynCourses.map((data) => Course.fromJson(data)).toList();
}
