import 'package:diary_of_teacher/src/models/group.dart';
import 'package:diary_of_teacher/src/models/student.dart';

import '../repository/students_repository.dart';

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
    listOfGroups.forEach((group){
      if (group.groupId.compareTo(groupId) == 0)
        name = group.name;
    });

    return name;
  }

  //Saving data to Firebase
  Future<bool> saveData() async {
    await _repository.saveToFirebase().catchError((error){
      throw error;
    });
    return true;
  }
}
