import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/lesson_controller.dart';
import 'package:diary_of_teacher/src/models/lesson.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:diary_of_teacher/src/ui/menu/lessons_subelements/LessonsEditor.dart';
import 'package:diary_of_teacher/src/ui/menu/lessons_subelements/lessons_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class ScheduleScreen extends StatefulWidget {
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<ScheduleScreen> {
  DateTime _selected;
  LessonController _controller;
  EventList<Lesson> _eventList;

  @override
  void initState() {
    super.initState();
    _controller = LessonController.getInstance();
    _eventList = EventList<Lesson>(events: _controller.events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400.0,
              child: CalendarCarousel<Lesson>(
                customGridViewPhysics: null,
                locale: "ru",
                onDayPressed: (dateTime, events) {
                  if (_selected == dateTime)
                    _selected = null;
                  else
                    _selected = dateTime;
                  setState(() {});
                },
                weekendTextStyle: TextStyle(color: Colors.red),
                thisMonthDayBorderColor: Colors.grey[200],
                daysHaveCircularBorder: true,
                headerTitleTouchable: true,
                weekdayTextStyle: TextStyle(color: Colors.black),
                iconColor: Colors.green[400],
                markedDatesMap: _eventList,
                markedDateIconMaxShown: 1,
                markedDateShowIcon: true,
                markedDateIconBuilder: (lesson) {
                  return Container(
                    padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                    child: Icon(Icons.school),
                  );
                },
                selectedDayButtonColor: theme.accentColor,
                selectedDayBorderColor: theme.accentColor,
                selectedDateTime: _selected,
                todayBorderColor: theme.buttonColor,
                todayTextStyle: TextStyle(color: Colors.black),
                todayButtonColor: theme.primaryColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FlatButton(
                  onPressed: _selected == null
                      ? null
                      : () async {
                          await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return LessonsEditor(
                              date: _selected,
                              lesson: null,
                            );
                          }));
                          setState(() {});
                        },
                  child: Text('Добавить занятие',
                      style: _selected == null ? disabledStyle : style),
                ),
                FlatButton(
                  onPressed: () async {
                    //Add lessons viewer
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return LessonsList();
                    }));

                    setState(() {});
                  },
                  child: Text('Посмотреть занятия', style: style),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: MenuDrawer(),
    );
  }
}

final TextStyle disabledStyle =
    TextStyle(fontSize: 15.0, letterSpacing: 0.0, color: Colors.grey[300]);
final TextStyle style =
    TextStyle(fontSize: 15.0, letterSpacing: 0.0, color: theme.accentColor);
