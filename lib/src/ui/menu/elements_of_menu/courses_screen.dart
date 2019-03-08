import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/controllers/course_controller.dart';
import 'package:diary_of_teacher/src/models/course.dart';
import 'package:diary_of_teacher/src/ui/menu/courses_subelements/course_lesson_editor.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CoursesScreen extends StatefulWidget {
  CoursesScreen({Key key}) : super(key: key);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  CourseController _controller = CourseController.getInstance();

  List<Course> courses;

  @override
  void initState() {
    super.initState();
    courses = _controller.courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Курсы'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .userRepository
                  .uploadAllDataToCloud()
                  .then((_) {
                Fluttertoast.showToast(msg: 'Данные загужены в облако');
              }).catchError((error) {
                Fluttertoast.showToast(msg: error);
              });
            },
            icon: Icon(Icons.cloud_upload),
            tooltip: 'Загрузить данные в облако',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
        children: courses.map((course) => getCourseCard(course)).toList(),
      ),
      drawer: MenuDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: showDialogToAddCourse,
        child: Icon(Icons.add),
        tooltip: 'Добавить курс',
      ),
    );
  }

  //Get card which contains information about one course
  Widget getCourseCard(Course course) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.black12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    course.courseName,
                    style: theme.textTheme.body1,
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          //Add new lesson to list
                          var less = CourseLesson(
                              title: 'Измените название',
                              textsList: [],
                              imagesList: []);
                          course.lessons.add(less);

                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CourseLessonEditor(
                                    lesson: less,
                                  )));
                          setState(() {});
                        },
                        child: Icon(
                          Icons.add_box,
                          color: theme.accentColor,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          courses.remove(course);
                          _controller.saveToCache().then((_) {
                            Fluttertoast.showToast(msg: 'Курс удалён');
                            setState(() {});
                          });
                        },
                        child: Icon(
                          Icons.delete_forever,
                          color: theme.accentColor,
                          size: 32.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: course.lessons
                      .map((lesson) => getCourseLessonItem(lesson, course))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: theme.primaryColorDark,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 6.0)]),
      ),
    );
  }

  //Get widget which contains information about one lesson from course
  Widget getCourseLessonItem(CourseLesson lesson, Course course) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (dir) {
        course.lessons.remove(lesson);
        _controller.saveToCache().then((_) {
          Fluttertoast.showToast(msg: 'Занятие удалено');
          setState(() {});
        }).catchError((err) => Fluttertoast.showToast(msg: err));
      },
      background: Container(
        alignment: AlignmentDirectional.centerStart,
        child: Icon(Icons.delete_sweep, color: Colors.white, size: 30.0,),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CourseLessonEditor(
                      lesson: lesson,
                    )));
            setState(() {});
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            child: Text(
              lesson.title,
              style: TextStyle(
                  fontSize: 20.0, fontFamily: 'Neucha', color: Colors.black),
            ),
            decoration: BoxDecoration(
                border:
                    Border.all(style: BorderStyle.solid, color: Colors.black45),
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    );
  }

  //Show dialog to input name of course and add it to list
  Future showDialogToAddCourse() async {
    TextEditingController textController = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              'Добавление нового курса',
            ),
            content: Container(
              width: 150.0,
              child: TextField(
                controller: textController,
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Neucha', fontSize: 20.0),
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18.0,
                        fontFamily: 'Neucha'),
                    hintText: 'Введите название курса'),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                color: theme.accentColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Отмена',
                  style: buttonTheme,
                ),
              ),
              RaisedButton(
                color: theme.accentColor,
                onPressed: () {
                  courses.add(Course(textController.text));
                  _controller.saveToCache().then((_) {
                    Fluttertoast.showToast(msg: 'Курс добавлен');
                    setState(() {});
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Добавить',
                  style: buttonTheme,
                ),
              ),
            ],
          );
        });
  }

  final buttonTheme = TextStyle(color: Colors.white, fontSize: 20.0);
}
