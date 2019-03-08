import 'dart:io';

import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/controllers/course_controller.dart';
import 'package:diary_of_teacher/src/models/course.dart';
import 'package:diary_of_teacher/src/ui/menu/courses_subelements/drowdown_menu.dart';
import 'package:diary_of_teacher/src/ui/menu/lessons_subelements/photo_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CourseLessonEditor extends StatefulWidget {
  CourseLessonEditor({Key key, @required this.lesson}) : super(key: key);

  //Lesson needs to modify info
  CourseLesson lesson;

  @override
  _CourseLessonEditorState createState() => _CourseLessonEditorState();
}

class _CourseLessonEditorState extends State<CourseLessonEditor> {
  CourseController _controller = CourseController.getInstance();
  TextEditingController _titleController;

  set title(String value) => widget.lesson.title = value;

  String get title => widget.lesson.title;

  List<String> get images => widget.lesson.imagesList;

  List<String> get texts => widget.lesson.textsList;

  //Mode when user can change title of lesson
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEditing ? getTitleEditor() : Text(title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.only(bottom: 16.0),
            children: <Widget>[
              //List of texts
              texts.isEmpty
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: texts.map((text) => getTextItem(text)).toList(),
                    ),

              SizedBox(
                height: 50.0,
              ),
              //List of images
              images.isEmpty
                  ? Container()
                  : Container(
                      height: 150.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: images
                            .map((image) => PhotoCard(
                                  photoUrl: image,
                                  deleteFunc: () {
                                    images.remove(image);
                                    setState(() {});
                                  },
                                ))
                            .toList(),
                      ),
                    ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: DropdownMenu(
              backgroundColor: theme.accentColor,
              iconColor: Colors.white,
              buttonsCount: 4,
              actions: [
                editTitle,
                () {
                  pickImage();
                },
                addText,
                () {
                  saveDataToCache();
                },
              ],
              icons: [
                Icons.edit,
                Icons.add_a_photo,
                Icons.text_fields,
                Icons.save
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addText() {
    texts.add('dauofhsdoifpjiqurmpeuwqrupmqwqwehqlweh');
    setState(() {});
  }

  void editTitle() {
    setState(() => isEditing = true);
  }
  //Item for displaying text
  Widget getTextItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Dismissible(
        key: Key(Uuid().v1()),
        direction: DismissDirection.startToEnd,
        onDismissed: (dir) {
          texts.remove(text);
        },
        background: Container(
          padding: const EdgeInsets.only(left: 5.0),
          alignment: AlignmentDirectional.centerStart,
          child: Icon(
            Icons.delete_sweep,
            color: Colors.white,
            size: 35.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.red[400],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            text,
            style: theme.textTheme.display4,
            softWrap: true,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: theme.primaryColor),
        ),
      ),
    );
  }

  //Picking image and upload it to firestore
  Future pickImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    _controller.uploadImageAndGetUrl(image).then((url) {
      images.add(url);
      Fluttertoast.showToast(msg: 'Фотография загружена');
      setState(() {});
    }).catchError((err) => Fluttertoast.showToast(msg: err));
  }

  //Save data to cache
  Future saveDataToCache() async {
    _controller
        .saveToCache()
        .then((_) => Fluttertoast.showToast(msg: 'Данные сохранены'))
        .catchError((err) => Fluttertoast.showToast(msg: err));
  }

  //Text editor to change title
  Widget getTitleEditor() {
    return Container(
      width: 200.0,
      height: 56.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Введите название',
                hintStyle: TextStyle(
                    fontFamily: 'Neucha',
                    fontSize: 18.0,
                    color: Colors.grey[500]),
              ),
              style: TextStyle(
                  color: theme.accentColor,
                  fontSize: 22.0,
                  fontFamily: 'Neucha',
                  fontWeight: FontWeight.w900),
            ),
          ),
          IconButton(
            onPressed: () {
              title = _titleController.text;
              setState(() => isEditing = false);
            },
            icon: Icon(
              Icons.check,
              size: 30.0,
              color: theme.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
