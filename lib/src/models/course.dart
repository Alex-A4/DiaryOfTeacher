import 'package:meta/meta.dart';

//POJO class to store information about one course
class Course {
  //Title of course
  //It's null if unspecified
  String title;

  //List of texts where user store the idea of lesson
  List<String> textsList;

  //List of images
  List<String> imagesList;

  //Default constructor
  //textsList and imagesList must not be null
  Course({@required this.title, this.textsList, this.imagesList})
      : assert(textsList != null),
        assert(imagesList != null);

  //Constructor to create object from Json data
  Course.fromJson(Map<dynamic, dynamic> data) {
    this.title = data['title'] ?? null;
    this.textsList = data['textsList'] ?? [];
    this.imagesList = data['imagesList'] ?? [];
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
