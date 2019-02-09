import 'package:uuid/uuid.dart';
import 'package:diary_of_teacher/src/models/student.dart';


//Class describes group of students
//Uses only runtime for easy access to sorted users
class Group {
  final String _groupId;
  final String _name;

  List<Student> _students = [];

  Group(this._name, {List<Student> students = const[]}):
      this._groupId = Uuid().v1() {
    for (var stud in students)
      this.addStudentToGroup(stud);
  }

  Group.fromJson(Map<String, dynamic> data) :
      _groupId = data['groupId'],
      _name = data['groupName'],
      _students = [];

  Map<String, dynamic> toJson() => {
    'groupId' : _groupId,
    'groupName' : _name,
  };

  String get name => _name;

  String get groupId => _groupId;


  @override
  String toString() => 'UID: $_groupId\nSTUDENTS IN GROUP: ${_students.toString()}\n';

  //Add student to that group
  void addStudentToGroup(Student student) {
    _students.add(student);
    student.groupId = _groupId;
  }

  //Remove student from that group
  void removeStudentFromGroup(Student student) {
    _students.remove(student);
    student.groupId = null;
  }
}