import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/ui/menu/menu_screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  AuthenticationBloc _authenticationBloc;
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
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Сменить пользователя',
              style: theme.textTheme.display1,
            ),
            onTap: (){
              _authenticationBloc.dispatch(SignOut());
            },
          ),
          Divider(),
        ],
      ),
      drawer: MenuDrawer(),
    );
  }
}