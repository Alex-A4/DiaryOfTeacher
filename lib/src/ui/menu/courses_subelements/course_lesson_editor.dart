import 'package:diary_of_teacher/src/models/course.dart';
import 'package:diary_of_teacher/src/ui/menu/courses_subelements/drowdown_menu.dart';
import 'package:flutter/material.dart';

class CourseLessonEditor extends StatefulWidget {
  CourseLessonEditor({Key key, @required this.course, @required this.lesson})
      : super(key: key);

  //Course needs to add lesson to course
  Course course;

  //Lesson needs to modify info
  CourseLesson lesson;

  @override
  _CourseLessonEditorState createState() => _CourseLessonEditorState();
}

class _CourseLessonEditorState extends State<CourseLessonEditor> {
  String title;
  List<String> images;
  List<String> texts;

  @override
  void initState() {
    super.initState();
    title = widget.lesson?.title ?? 'Название занятия ';
    images = widget.lesson?.imagesList ?? [];
    texts = widget.lesson?.textsList ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: DropdownMenu(),
          ),
        ],
      ),
    );
  }
}
