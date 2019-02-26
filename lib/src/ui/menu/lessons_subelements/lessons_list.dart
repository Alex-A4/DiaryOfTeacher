import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/lesson_controller.dart';
import 'package:diary_of_teacher/src/models/lesson.dart';
import 'package:diary_of_teacher/src/ui/menu/lessons_subelements/LessonsEditor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LessonsList extends StatefulWidget {
  LessonsList({Key key}) : super(key: key);

  @override
  _LessonsListState createState() => _LessonsListState();
}

class _LessonsListState extends State<LessonsList> {
  LessonController _controller = LessonController.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список занятий'),
        elevation: 5.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {
              _controller.saveToFirestore().then((_) {
                Fluttertoast.showToast(msg: 'Данные загужены в облако');
              }).catchError((error) {
                Fluttertoast.showToast(msg: error.toString());
              });
            },
            tooltip: 'Загрузить уроки в облако',
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        children: _controller.events.keys
            .map((date) => getDatedLessons(date))
            .toList(),
      ),
    );
  }

  //Get column of lessons by specified date from events map
  Widget getDatedLessons(DateTime date) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: theme.primaryColor,
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                getDateToShow(date),
                style: theme.textTheme.display4,
              ),
              Divider(),
              Column(
                children: _controller.events[date]
                    .map((lesson) => getLessonItem(lesson))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Get date to show like dd.mm.yyyy
  String getDateToShow(DateTime date) {
    if (date == null) return 'Дата не указана';
    return 'Дата занятий: ${date.day}.${date.month}.${date.year}';
  }

  //Get item which contains info about one lesson
  Widget getLessonItem(Lesson lesson) {
    return Container(
      child: ListTile(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LessonsEditor(
              lesson: lesson,
            );
          }));
          setState(() {});
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Время: ${getStringTime(lesson.lessonTime)}. Группа ${lesson.groupToStudy?.name ?? 'не указана'}'),
          ],
        ),
      ),
    );
  }

  //Get time to show like hh:mm
  String getStringTime(DateTime time) {
    if (time == null) return 'Время не указано';
    return '${time.hour}:${time.minute}';
  }
}
