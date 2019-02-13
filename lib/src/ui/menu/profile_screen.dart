import 'dart:io';

import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:diary_of_teacher/src/repository/UserRepository.dart';
import 'package:diary_of_teacher/src/ui/menu/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _controller;
  bool isEditing = false;
  final _key = GlobalKey<FormState>();
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: User.user.userName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Мой профиль'),
          centerTitle: true,
        ),
        drawer: MenuDrawer(),
        body: Container(
            child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 232.0,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(User.user.photoUrl),
                          radius: 100,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                tryToUpdateImage();
                                print('Button tapped');
                              },
                              iconSize: 80.0,
                              color: Colors.white70,
                              icon: Icon(Icons.camera_alt),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 50.0, right: 30.0, top: 30.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Form(
                              key: _key,
                              child: TextFormField(
                                focusNode: _focus,
                                textAlign: TextAlign.center,
                                controller: _controller,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  hintText: 'Введите имя',
                                ),
                                enabled: isEditing,
                                style: theme.textTheme.body1,
                                validator: (value) {
                                  if (value.length == 0)
                                    return 'Имя не должно быть пустым';
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            color: Color(0xFFb4e99b),
                            icon: Icon(isEditing ? Icons.done : Icons.edit),
                            onPressed: () {
                              if (isEditing && validate()) {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                                return;
                              }
                              if (!isEditing) {
                                startEdit();
                                return;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )));
  }

  //Validate the user name
  bool validate() {
    if (_key.currentState.validate()) return true;
    return false;
  }

  //Start editing and put focus to TextField for name
  void startEdit() {
    FocusScope.of(context).requestFocus(_focus);
    setState(() {
      isEditing = !isEditing;
    });
  }


  //Update the image by picking from gallery
  Future tryToUpdateImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      UserRepository.uploadUserImage(imageFile).then((_) {
        Fluttertoast.showToast(msg: 'Фотография изменена успешно');
        setState(() {});
      }).catchError((err) => Fluttertoast.showToast(msg: err));
    }
  }
}
