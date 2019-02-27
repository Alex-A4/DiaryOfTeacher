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
    //If events at date is empty
    if (_controller.events[date].length < 1) return Container();

    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: theme.primaryColorDark,
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                getDateToShow(date),
                style: TextStyle(color: theme.accentColor, fontSize: 17.0),
              ),
              Divider(),
              Column(
                children: _controller.events[date]
                    .map((lesson) => getLessonItem(lesson, date))
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
    String dayZero = '';
    String monthZero = '';
    if (date.day < 10) dayZero = '0';
    if (date.month < 10) monthZero = '0';

    return 'Дата занятий: $dayZero${date.day}.$monthZero${date.month}.${date.year}';
  }

  //Get item which contains info about one lesson
  Widget getLessonItem(Lesson lesson, DateTime date) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        _controller.removeLessonFromDate(date, lesson);
        setState(() {});
      },
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red[400],
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            Icons.delete,
            color: Colors.white70,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        onTap: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return LessonsEditor(
              date: date,
              lesson: lesson,
            );
          }));
          setState(() {});
        },
        leading: Text('${getStringTime(lesson.lessonTime)}'),
        title: Text('Группа ${lesson.groupToStudy?.name ?? 'не указана'}'),
        subtitle: Text(
          'Тема: ${lesson.theme}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15.0, color: Colors.black38),
        ),
      ),
    );
  }

  //Get time to show like hh:mm
  String getStringTime(TimeOfDay time) {
    if (time == null) return 'Время не указано';
    if (time.minute < 10) return '${time.hour}:0${time.minute}';

    return '${time.hour}:${time.minute}';
  }
}
