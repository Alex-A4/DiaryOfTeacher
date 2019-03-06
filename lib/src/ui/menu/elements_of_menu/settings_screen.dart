import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/controllers/lesson_controller.dart';
import 'package:diary_of_teacher/src/repository/UserRepository.dart';
import 'package:diary_of_teacher/src/repository/students_repository.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  AuthenticationBloc _authenticationBloc;
  UserRepository userRepository;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    userRepository = _authenticationBloc.userRepository;
  }

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.cloud_download),
            title: Text(
              'Восстановить данные из облака',
              style: theme.textTheme.display1,
            ),
            onTap: () {
              showDialogToAcceptRestore();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.autorenew),
            title: Text(
              'Сменить пароль',
              style: theme.textTheme.display1,
            ),
            onTap: () {
              showDialogToChangePassword();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Сменить пользователя',
              style: theme.textTheme.display1,
            ),
            onTap: () {
              _authenticationBloc.dispatch(SignOut());
            },
          ),
          Divider(),
        ],
      ),
      drawer: MenuDrawer(),
    );
  }

  //Show dialog with warning that user must accept or deny
  Future showDialogToAcceptRestore() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ВНИМАНИЕ!  ',
                  style: TextStyle(color: Colors.red[400], fontSize: 21.0),
                ),
                Icon(
                  Icons.warning,
                  color: Colors.red[400],
                ),
              ],
            ),
            content: Container(
              child: Text(
                'Все несохранённые данные будут перезаписаны.\n\nПродолжить?',
                maxLines: 4,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Нет',
                  style: TextStyle(color: theme.accentColor, fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                onPressed: () {
                  restoreDataFromFirestore();
                },
                child: Text('Да',
                    style: TextStyle(color: theme.accentColor, fontSize: 18.0)),
              )
            ],
          );
        });
  }

  //Show dialog to user to change password
  Future showDialogToChangePassword() async {
    _newPassword.clear();
    _oldPassword.clear();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              'Сменить пароль',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 23.0),
            ),
            content: Container(
              height: 100.0,
              child: Form(
                key: _key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    getPasswordField('Старый пароль', _oldPassword),
                    getPasswordField('Новый пароль', _newPassword),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Отменить',
                    style: buttonTheme,
                  )),
              FlatButton(
                  onPressed: () {
                    if (_key.currentState.validate()) tryToChangePassword();
                  },
                  child: Text(
                    'Сменить',
                    style: buttonTheme,
                  )),
            ],
          );
        });
  }

  //Get TextFormField for passwords
  Widget getPasswordField(String hintText, TextEditingController controller) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: true,
        textAlign: TextAlign.center,
        maxLength: 6,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textHintTheme,
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12)),
        ),
        style: textInputTheme,
        validator: (text) {
          if (text.length != 6) return 'Длина пароля не равна 6';
        },
      ),
    );
  }

  //Firstly check correct of old password and if it's right
  // then create new password
  Future tryToChangePassword() async {
    if (await userRepository.checkPasswordCorrect(_oldPassword.text)) {
      //Change password in store
      await userRepository.savePassword(_newPassword.text);
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Пароль успешно изменён');
    } else {
      Fluttertoast.showToast(msg: 'Пароль неверный');
    }
  }

  //Restore all data from the firestore and notify user about complete or error
  Future restoreDataFromFirestore() async {
    Navigator.of(context).pop();

    await userRepository
        .restoreAllDataFromCloud()
        .then((_) => Fluttertoast.showToast(msg: 'Данные восстановлены'))
        .catchError((error) => Fluttertoast.showToast(msg: error.toString()));
  }

  final textInputTheme = TextStyle(fontSize: 20.0, color: Colors.black);
  final textHintTheme = TextStyle(
      fontSize: 20.0,
      color: Colors.black38,
      letterSpacing: 1.0,
      fontFamily: 'Neucha');
  final buttonTheme = TextStyle(fontSize: 20.0, color: theme.accentColor);
}
