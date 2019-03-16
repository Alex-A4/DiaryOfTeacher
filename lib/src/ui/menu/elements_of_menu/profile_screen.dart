import 'dart:io';

import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:diary_of_teacher/src/repository/UserRepository.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:diary_of_teacher/src/ui/menu/lessons_subelements/photo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  UserRepository userRepository;

  bool _isLoadingImage = false;
  bool _isLoadingName = false;

  @override
  void initState() {
    super.initState();
    userRepository =
        BlocProvider.of<AuthenticationBloc>(context).userRepository;
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
                        child: InkWell(
                          onTap: showActionPhotoDialog,
                          child: CircleAvatar(
                            backgroundImage: AdvancedNetworkImage(
                                User.user.photoUrl,
                                useDiskCache: true,
                                cacheRule:
                                    CacheRule(maxAge: Duration(days: 7))),
                            radius: 100,
                            child: Center(
                              child: _isLoadingImage
                                  ? CircularProgressIndicator()
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 50.0, right: 30.0, top: 30.0, bottom: 10.0),
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
                                style: TextStyle(
                                    fontFamily: 'Neucha',
                                    fontSize: 25.0,
                                    letterSpacing: 0.0,
                                    color: Colors.black),
                                validator: (value) {
                                  if (value.length == 0)
                                    return 'Имя не должно быть пустым';
                                },
                              ),
                            ),
                          ),
                          _isLoadingName
                              ? CircularProgressIndicator()
                              : IconButton(
                                  color: theme.accentColor,
                                  icon:
                                      Icon(isEditing ? Icons.done : Icons.edit),
                                  onPressed: () {
                                    if (isEditing && validate()) {
                                      setState(() {
                                        isEditing = !isEditing;
                                      });
                                      tryToUpdateName();
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

  Future tryToUpdateName() async {
    String userName = _controller.text;

    startLoadingName();

    userRepository.uploadUserName(userName).then((_) {
      Fluttertoast.showToast(msg: 'Имя обновлено');
      finishLoadingName();
    }).catchError((er) {
      Fluttertoast.showToast(msg: er.toString());
      finishLoadingName();
    });
  }

  //Update the image by picking from gallery
  Future tryToUpdateImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      startLoadingImage();

      userRepository.uploadUserImage(imageFile).then((_) {
        Fluttertoast.showToast(msg: 'Фотография изменена успешно');
        finishLoadingImage();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err);
        finishLoadingImage();
      });
    }
  }

  //Show dialog when user tap on profile image
  //Actions: open image, upload new image
  void showActionPhotoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            backgroundColor: theme.primaryColor,
            child: Container(
              width: 150.0,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Фото',
                    style: theme.textTheme.body1,
                  ),
                  ListTile(
                    title: Text(
                      'Открыть',
                      style: dialogButtonTheme,
                    ),
                    leading: Icon(
                      Icons.open_in_new,
                      color: theme.accentColor,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          PhotoDisplayRoute(photoUrl: User.user.photoUrl));
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Загрузить',
                      style: dialogButtonTheme,
                    ),
                    leading: Icon(
                      Icons.photo_size_select_actual,
                      color: theme.accentColor,
                    ),
                    onTap: () {
                      tryToUpdateImage()
                          .then((_) => Navigator.of(context).pop());
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  final dialogButtonTheme = TextStyle(color: theme.accentColor, fontSize: 20.0);

  //Start loading of user name
  void startLoadingName() => setState(() {
        _isLoadingName = true;
      });

  //Finish loading of user name
  void finishLoadingName() => setState(() {
        _isLoadingName = false;
      });

  //Start loading of image
  void startLoadingImage() => setState(() {
        _isLoadingImage = true;
      });

  //Stop loading of image
  void finishLoadingImage() => setState(() {
        _isLoadingImage = false;
      });
}
