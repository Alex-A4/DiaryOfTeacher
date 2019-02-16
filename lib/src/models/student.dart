import 'package:diary_of_teacher/src/repository/students_repository.dart';
import 'package:uuid/uuid.dart';

//Class describes one student which can be serialized
class Student {
  static const String defaultPhotoUrl =
      'https://firebasestorage.googleapis.com/v0/b/diary-of-teacher-46bf7.appspot.com/o/sheepTP.png?alt=media&token=d01ead7c-7c80-499d-99aa-e21ca7f4eb49';

  final String uid;

  String fio;
  String groupId;
  String photoUrl;
  String characteristic;
  String course;
  DateTime studyingSince;
  DateTime studyingTo;

  //This constructor needs for first create Student
  Student(
      {this.fio,
      this.groupId,
      this.photoUrl = defaultPhotoUrl,
      this.characteristic,
      this.course,
      this.studyingSince,
      this.studyingTo})
      : uid = Uuid().v1();

  //This constructor needs to restore Student from store
  Student.fromJson(Map<String, dynamic> data) : this.uid = data['uid'] {
    this.fio = data['fio'];
    this.groupId = data['groupId'];
    this.photoUrl = data['photoUrl'] ?? defaultPhotoUrl;
    this.characteristic = data['characteristic'];
    this.course = data['cource'];
    this.studyingSince = data['studyingSince'] != null
        ? DateTime.parse(data['studyingSince'])
        : null;
    this.studyingTo =
        data['studyingTo'] != null ? DateTime.parse(data['studyingTo']) : null;
  }

  //Converting student to JSON
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fio': fio,
        'groupId': groupId,
        'photoUrl': photoUrl,
        'characteristic': characteristic,
        'cource': course,
        'studyingSince':
            studyingSince != null ? studyingSince.toUtc().toString() : null,
        'studyingTo': studyingTo != null ? studyingTo.toUtc().toString() : null,
      };

  @override
  String toString() => 'UID: $uid, GROUPID: $groupId';


  //Update data of current student by new data
  void updateData(Student newData) {
    this.fio = newData.fio;
    this.photoUrl = newData.photoUrl;
    this.course = newData.course;
    this.characteristic = newData.characteristic;
    updateGroupId(newData.groupId);
    this.studyingSince = newData.studyingSince;
    this.studyingTo = newData.studyingTo;
  }

  //Update groupId and bind student with group if need
  void updateGroupId(String id) {
    if (this.groupId != id) {
      //Delete student from previous group
      if (this.groupId != null) {
        var oldGroup = StudentsRepository.getInstance().getGroupById(
            this.groupId);
        oldGroup.removeStudentFromGroup(this);
      }

      this.groupId = id;
      if (this.groupId != null) {
        var group = StudentsRepository.getInstance().getGroupById(id);
        group.addStudentToGroup(this);
        print('Student: ${this}\nGroup:${group}');
      }
    }
  }
}
