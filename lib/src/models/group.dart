import 'package:diary_of_teacher/src/controllers/course_controller.dart';
import 'package:diary_of_teacher/src/models/course.dart';
import 'package:uuid/uuid.dart';
import 'package:diary_of_teacher/src/models/student.dart';

//Class describes group of students
//Uses only runtime for easy access to sorted users
class Group {
  final String _groupId;
  String _name;
  Course course;

  List<Student> _students = [];

  Group(this._name) : this._groupId = Uuid().v1();

  Group.fromJson(Map<dynamic, dynamic> data)
      : _groupId = data['groupId'],
        _name = data['groupName'],
        _students = [],
        course =
            CourseController.getInstance().getCourseById(data['courseUid']);

  Map<String, dynamic> toJson() => {
        'groupId': _groupId,
        'groupName': _name,
        'courseUid': course.uuid,
      };

  set name(String value) => _name = value;

  List<Student> get students => _students;

  String get name => _name;

  String get groupId => _groupId;

  @override
  String toString() =>
      'UID: $_groupId\nSTUDENTS IN GROUP: ${_students.toString()}\n';

  //Add student to that group
  void addStudentToGroup(Student student) {
    ///Check is student already added
    bool isContains = false;
    _students.forEach((stud) {
      if (stud.uid == student.uid) isContains = true;
    });
    if (!isContains) _students.add(student);

    student.groupId = _groupId;
  }

  //Remove student from that group
  void removeStudentFromGroup(Student student) {
    _students.remove(student);
    student.groupId = null;
  }

  //First delete links to group at all students
  //Then clear _students list
  void deleteAllStudents() {
    _students.forEach((stud) => stud.groupId = null);
    _students = null;
  }

  //Update group name
  void updateName(String name) {
    this.name = name;
  }

  //Update the course
  void updateCourse(Course newCourse) {
    this.course = newCourse;
  }
}
