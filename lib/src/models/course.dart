import 'package:meta/meta.dart';

//POJO class to store information about one course
class Course {
  String courseName;

  //List of lessons of which course consist
  List<CourseLesson> lessons;

  //Default constructor
  Course(this.courseName) : lessons = [];

  //Restore course from Json
  Course.fromJson(Map<dynamic, dynamic> course) {
    this.courseName = course['courseName'];
    this.lessons = [];
    course['lessons'].forEach((lesson) => lessons.add(CourseLesson.fromJson(lesson)));
  }

  //Convert course object to json
  Map<String, dynamic> toJson() {
    return {
      'courseName': courseName,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}

class CourseLesson {
  //Title of course lesson
  //It's null if unspecified
  String title;

  //List of texts where user store the idea of lesson
  List<String> textsList;

  //List of images
  List<String> imagesList;

  //Default constructor
  //textsList and imagesList must not be null
  CourseLesson({@required this.title, this.textsList, this.imagesList})
      : assert(textsList != null),
        assert(imagesList != null);

  //Constructor to create object from Json data
  CourseLesson.fromJson(Map<dynamic, dynamic> data) {
    this.title = data['title'] ?? null;
    this.textsList = [];
    data['textsList'].forEach((value) => textsList.add(value as String));
    this.imagesList = [];
    data['imagesList'].forEach((value) => imagesList.add(value as String));
  }

  //Convert object to Json object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'textsList': textsList,
      'imagesList': imagesList,
    };
  }
}
