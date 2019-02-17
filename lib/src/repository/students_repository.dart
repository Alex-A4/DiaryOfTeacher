import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:diary_of_teacher/src/models/group.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';
import 'dart:convert' show JsonCodec;


//Repository of students and groups
//Uses in the sense of Model in MVC
//Returns data by requests and handle it
class StudentsRepository {
  //Instance of Json codec
  static JsonCodec _decoder = JsonCodec();

  //Singleton instance of repository
  static StudentsRepository _studentsRepository;

  List<Group> _groups = [];
  List<Group> get groups => _groups;
  //Get group by id. id must not be null
  Group getGroupById(String id) {
    Group group;
    groups.forEach((gr) {
      if (gr.groupId.compareTo(id) == 0)
        group = gr;
    });

    return group;
  }

  List<Student> _students = [];

  List<Student> get students => _students;

  //Getting instance of repository
  static StudentsRepository getInstance() {
    return _studentsRepository;
  }

  //Building repository after the login
  static Future buildRepo() async {
    if (_studentsRepository == null) {
      _studentsRepository = StudentsRepository._();
      await _studentsRepository._fromCache();
    }
  }
  StudentsRepository._();

  //Read data from cache
  Future _fromCache() async {
    SharedPreferences cache = await SharedPreferences.getInstance();
    //Reading groups from cache
    String groupsRaw = cache.getString('groups');
    print('GROUPS RAW: ${groupsRaw}');
    if (groupsRaw != null && groupsRaw.compareTo('[]') != 0) {
      List<dynamic> groups = _decoder.decode(groupsRaw);
      _groups = groups.map((data) => Group.fromJson(data)).toList();
    } else
      _groups = [];

    //Reading students from cache
    String studentsRaw = cache.getString('students');
    print('STUDENTS RAW: ${studentsRaw}');
    if (studentsRaw != null && studentsRaw.compareTo('[]') != 0) {
      List<dynamic> students = _decoder.decode(studentsRaw);
      _students = students.map((data) => Student.fromJson(data)).toList();
    } else
      _students = [];

    //Distribute students by groups
    _students.forEach((student) {
      _groups.forEach((group) {
        //If student from that group then move it here
        if (group.groupId != null && student.groupId != null) {
          if (group.groupId.compareTo(student.groupId) == 0) {
            group.addStudentToGroup(student);
            return;
          }
        }
      });
    });

    print('GROUPS LENGTH: ${_groups.length}');
    print('STUDENTS LENGTH: ${_students.length}');
  }

  //Saving all data to cache as SharedPreferences
  Future saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Saving groups
    List<dynamic> groups = convertGroupsToJson();
    await prefs.setString('groups', _decoder.encode(groups));

    //Saving students
    List<dynamic> students = convertStudentsToJson();
    await prefs.setString('students', _decoder.encode(students));
    print('Cache saved!');
  }

  //Converting list of students to Json string
  List<dynamic> convertStudentsToJson() {
    List<Map<String, dynamic>> studentsList = [];
    _students.forEach((student) => studentsList.add(student.toJson()));
    return studentsList;
  }

  //Converting list of groups to Json string
  List<dynamic> convertGroupsToJson() {
    List<Map<String, dynamic>> groupsList = [];
    _groups.forEach((group) => groupsList.add(group.toJson()));
    return groupsList;
  }

  //Saving data to cloud Firebase
  Future saveToFirebase() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';


    //Saving groups
    List<dynamic> groups = convertGroupsToJson();
    await Firestore.instance
        .collection('users')
        .document(User.user.uid)
        .updateData({'groups': groups});

    //Saving students
    List<dynamic> students = convertStudentsToJson();
    await Firestore.instance
        .collection('users')
        .document(User.user.uid)
        .updateData({'students': students});

    print('Firebase saved');
  }

  //Add new student to list if group not selected then it's null
  //It could be add later
  void addNewStudent(Student student) {
    _students.add(student);

    //Distribute student and group
    if (student.groupId != null) {
      getGroupById(student.groupId).addStudentToGroup(student);
    }
  }

  //Delete user from cache and Firebase
  //Cache will update after dispose menu screen
  Future deleteStudentAndSaveResult(Student student) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';

    if (student.groupId != null)
      getGroupById(student.groupId)?.removeStudentFromGroup(student);

    _students.remove(student);

    saveToFirebase();
    await saveToCache();
  }

  //Add student to archive
  // by deleting it from both collections
  // and add user to archive collection
  Future archiveStudent(Student student) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';

    if (student.groupId != null)
      getGroupById(student.groupId)?.removeStudentFromGroup(student);

    _students.remove(student);

    await saveToFirebase();
    await Firestore.instance.collection('users').document(User.user.uid)
      .collection('archive').document('archivedStudents')
      .setData({student.uid : student.toJson()});
    await saveToCache();
  }


  //Add new group to list and save data to cache
  void addNewGroup(Group group) {
    _groups.add(group);

    saveToCache();
  }


  //Delete group and all links from students
  //Save result to firebase and to cache
  Future deleteGroupAndSaveResult(Group group) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw 'Отсутствует интернет соединение';

    group.deleteAllStudents();
    _groups.remove(group);

    await saveToFirebase();
    await saveToCache();
  }
}
