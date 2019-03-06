import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diary_of_teacher/src/controllers/timeout_controller.dart';
import 'package:diary_of_teacher/src/models/list_of_images.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu/drawer.dart';
import 'package:diary_of_teacher/src/ui/menu/lessons_subelements/photo_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class TimeoutScreen extends StatefulWidget {
  _TimeoutState createState() => _TimeoutState();
}

class _TimeoutState extends State<TimeoutScreen> {
  TimeoutController _controller = TimeoutController.getInstance();
  ListOfImages list;

  @override
  Widget build(BuildContext context) {
    list = _controller.images;

    return Scaffold(
      appBar: AppBar(
        title: Text('Перерыв'),
      ),
      body: GridView.builder(
        itemCount: list.urls.length,
        itemBuilder: (context, index) {
          return Container(
            child: PhotoCard(photoUrl: list.urls[index],boxFit: BoxFit.contain, background: Colors.transparent,),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      ),
      drawer: MenuDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageAndTryToUpload,
        child: Icon(Icons.add),
        tooltip: 'Загрузить фото',
      ),
    );
  }

  //Get image with picker and try to upload it to cloud
  Future getImageAndTryToUpload() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null)
      _controller.uploadImage(image).then((_) {
        Fluttertoast.showToast(msg: 'Фото загружено');
        setState(() {});
      }).catchError((err) => Fluttertoast.showToast(msg: err));
  }
}
