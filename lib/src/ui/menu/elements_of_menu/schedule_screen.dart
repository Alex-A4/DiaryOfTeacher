import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/models/lesson.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class ScheduleScreen extends StatefulWidget {
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<ScheduleScreen> {
  DateTime _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание'),
      ),
      body: Container(
        child: CalendarCarousel<Lesson>(
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
//            markedDatesMap: ,

          selectedDayButtonColor: theme.accentColor,
          selectedDayBorderColor: theme.accentColor,
          selectedDateTime: _selected,

          todayBorderColor: theme.buttonColor,
          todayTextStyle: TextStyle(color: Colors.black),
          todayButtonColor: theme.primaryColor,
        ),
      ),
      drawer: MenuDrawer(),
    );
  }
}
