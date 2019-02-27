import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInScreen extends StatefulWidget {
  _LogIn createState() => _LogIn();
}

class _LogIn extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  var _passwordController;
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Вход'),
      ),
      body: ListView(
        padding: EdgeInsets.all(32.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/login_picture.png',
                fit: BoxFit.fitHeight,
                height: 200.0,
              ),
              SizedBox(
                height: 50.0,
              ),
              Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: 'Введите пароль',
                    ),
                    style: theme.textTheme.body1,
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    validator: (pass) {
                      if (pass.isEmpty) return 'Введите пароль';
                      if (pass.length != 6)
                        return 'Пароль должен состоять из 6 символов';
                    },
                    textAlign: TextAlign.center,
                    maxLength: 6,
                  )),
              RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: theme.buttonColor,
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  ' Войти ',
                  style: TextStyle(fontSize: 20.0, letterSpacing: 1.0, color: Colors.black),
                ),
                onPressed: (){
                  if (_formKey.currentState.validate()) {
                    _authenticationBloc.dispatch(LogIn(_passwordController.text));
                  }
                  _passwordController.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
