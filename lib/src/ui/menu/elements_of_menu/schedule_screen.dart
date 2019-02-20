import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/models/lesson.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class ScheduleScreen extends StatefulWidget {
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<ScheduleScreen> {
  DateTime _selected;
//  Map<DateTime, List<Lesson>> events = {};
//  EventList list;


  @override
  void initState() {
    super.initState();
  }


  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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

//                markedDatesMap: list,
                markedDateIconMaxShown: 1,
                markedDateShowIcon: true,
                markedDateIconBuilder: (lesson){
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
                  onPressed: (){

                  },
                  child: Text('Добавить занятие', style: style),
                ),
                FlatButton(
                  onPressed: (){

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

final TextStyle style = TextStyle(fontSize: 15.0, letterSpacing: 0.0, color: theme.accentColor);
