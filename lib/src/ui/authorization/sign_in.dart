import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Авторизация'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/login_picture.png',
                    height: 200.0,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _authenticationBloc.dispatch(SignIn());
                    },
                    child: Text(
                      'войти с помощью гугл'.toUpperCase(),
                      style: theme.textTheme.body2,
                      textAlign: TextAlign.center,
                    ),
                    elevation: 5.0,
                    color: theme.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
