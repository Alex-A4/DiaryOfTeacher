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
  List<Course> courses;

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
      courses = convertJsonToCourses(_codec.decode(line));
    } else
      courses = [];

    print('Courses restored ${courses.length}');
  }

  //Saving all courses to cache
  Future saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('courses', _codec.encode(convertListToJson()));
    print('Courses saved to cache');
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
        .setData({'courses': convertListToJson()});
    print('Courses uploaded');
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
    courses = convertJsonToCourses(snapshot.data['courses']);

    await saveToCache();
    print('Courses restored');
  }

  //Convert list of courses to dynamic list
  List<Map<String, dynamic>> convertListToJson() =>
      courses.map((data) => data.toJson()).toList();

  //Convert dynamic list to list of courses
  List<Course> convertJsonToCourses(List<dynamic> dynCourses) =>
      dynCourses.map((data) => Course.fromJson(data)).toList();

  //Return course by specified uuid
  //If there is no courses then return null
  Course getCourseById(String uuid) {
    Course course = null;
    if (uuid != null)
      courses.forEach((cour) {
        if (cour.uuid.compareTo(uuid) == 0) {
          course = cour;
          return;
        }
      });

    return course;
  }
}
