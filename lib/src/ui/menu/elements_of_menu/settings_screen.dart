import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/repository/UserRepository.dart';
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

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'Сменить пароль',
              style: theme.textTheme.display1,
            ),
            onTap: () {
              showDialogToChangePassword(context);
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

  //TODO: change underline color at textField
  //Show dialog to user to change password
  Future showDialogToChangePassword(BuildContext context) async {
    _newPassword.clear();
    _oldPassword.clear();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Сменить пароль'),
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
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
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
    if (await UserRepository.checkPasswordCorrect(_oldPassword.text)) {
      //Change password in store
      await UserRepository.savePassword(_newPassword.text);
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Пароль успешно изменён');
    } else {
      Fluttertoast.showToast(msg: 'Пароль неверный');
    }
  }

  final textHintTheme = TextStyle(fontSize: 20.0, color: Colors.black38);
  final textInputTheme = TextStyle(fontSize: 20.0, color: Colors.black);
  final buttonTheme = TextStyle(fontSize: 20.0, color: theme.buttonColor);
}
