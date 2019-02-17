import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/ui/menu/elements_of_menu//drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  AuthenticationBloc _authenticationBloc;

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


  //TODO: add mehtod to change password
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _oldPassword,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Старый пароль',
                        hintStyle: textHintTheme,
                      ),
                      style: textInputTheme,
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: _newPassword,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Новый пароль',
                        hintStyle: textHintTheme,
                      ),
                      style: textInputTheme,
                    ),
                  ),
                ],
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
                  onPressed: () {},
                  child: Text(
                    'Сменить',
                    style: buttonTheme,
                  )),
            ],
          );
        });
  }

  final textHintTheme = TextStyle(fontSize: 20.0, color: Colors.black38);
  final textInputTheme = TextStyle(fontSize: 20.0, color: Colors.black);
  final buttonTheme = TextStyle(fontSize: 20.0, color: theme.buttonColor);
}
