import 'package:diary_of_teacher/src/models/group.dart';
import 'package:diary_of_teacher/src/models/student.dart';

import '../repository/students_repository.dart';

//Controller of students
//Uses in sense of Controller in MVC
//Needs to flow data between [StudentsRepository] and view
// with the help of callbacks
class StudentsController {
  static StudentsController _controller;
  StudentsRepository _repository;

  static StudentsController getInstance() {
    if (_controller == null) {
      _controller = new StudentsController._(StudentsRepository.getInstance());
    }

    return _controller;
  }

  StudentsController._(this._repository);

  List<Student> get listOfStudents => _repository.students;

  List<Group> get listOfGroups => _repository.groups;

  //Getting group name by input id
  String getGroupNameById(String groupId) {
    String name = '';

    if (groupId == null) return name;

    listOfGroups.forEach((group) {
      if (group.groupId.compareTo(groupId) == 0) name = group.name;
    });

    return name;
  }

  //Saving data to Firebase
  Future<bool> saveDataToFirebase() async {
    await _repository.saveToFirebase().catchError((error) {
      throw error;
    });
    return true;
  }

  //Add new user to repository
  void addNewStudent(Student student) {
    _repository.addNewStudent(student);
  }

  //Deleting user from repository
  Future deleteStudent(Student student) async {
    await _repository
        .deleteStudentAndSaveResult(student)
        .catchError((error) => throw error);
  }

  //Add new group to repository
  void addNewGroup(Group group) {
    _repository.addNewGroup(group);
  }

  //Add student to archive in firebase
  Future archiveStudent(student) async {
    await _repository.archiveStudent(student);
  }

  Future<Null> saveDataToCache() async {
    _repository.saveToCache();
  }

  //Delete group from repository
  Future deleteGroup(Group group) async {
    await _repository
        .deleteGroupAndSaveResult(group)
        .catchError((error) => throw error);
  }
}
