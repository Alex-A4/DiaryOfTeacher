import 'package:diary_of_teacher/src/models/user.dart';
import 'package:diary_of_teacher/src/network/authorization.dart';
import 'package:diary_of_teacher/src/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen();

  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
          title: Text('Добро пожаловать'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                handleSignOut(context);
              },
            )
          ],
        ),
        drawer: MyDrawer(),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      User.user.photoUrl),
                                  radius: 100,
                                ),
                              ),
                              Center(
                                child: IconButton(
                                  onPressed: () {
                                    print('Button tapped');
                                  },
                                  iconSize: 80.0,
                                  color: Colors.white70,
                                  icon: Icon(Icons.camera_alt),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 30.0),
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
                                        hintText: 'Введите имя',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFFFC4D1),
                                        )),
                                    enabled: isEditing,
                                    style: TextStyle(
                                      color: Color(0xFFFFC4D1),
                                      fontSize: 23.0,
                                    ),
                                    validator: (value) {
                                      if (value.length == 0)
                                        return 'Имя не должно быть пустым';
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(isEditing ? Icons.done : Icons.edit),
                                onPressed: () {
                                  if (isEditing && complete()) {
                                    setState(() {
                                      isEditing = !isEditing;
                                    });
                                    return;
                                  }
                                  if (!isEditing) {
                                    startEdit();
                                    setState(() {
                                      isEditing = !isEditing;
                                    });
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

  bool complete() {
    if (_key.currentState.validate()) return true;
    return false;
  }

  void startEdit() {
    FocusScope.of(context).requestFocus(_focus);
  }
}
