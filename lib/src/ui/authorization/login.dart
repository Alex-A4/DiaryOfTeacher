import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/ui/authorization/time_passer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInScreen extends StatefulWidget {
  _LogIn createState() => _LogIn();
}

class _LogIn extends State<LogInScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _passwordController;
  AuthenticationBloc _authenticationBloc;
  PasserController _passerController;

  //Animation which needs to make "vibrate" animation
  AnimationController _buttonController;
  Animation<double> vibrateTranslate;

  //How much times button dragged
  int countOfVibrates = 0;

  int countOfWrongPasswordEnters = 0;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _passwordController = TextEditingController();
    _passerController = PasserController(vsync: this, secondsToPass: 30);

    _buttonController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 50))
      ..addStatusListener((status) {
        if (countOfVibrates < 10) {
          if (status == AnimationStatus.completed) {
            countOfVibrates++;
            _buttonController.reverse();
          }
          if (status == AnimationStatus.dismissed) {
            countOfVibrates++;
            _buttonController.forward();
          }
        } else countOfVibrates = 0;
      });

    final anim = CurvedAnimation(
        parent: _buttonController, curve: Curves.linear);
    vibrateTranslate = Tween<double>(begin: 0.0, end: 10.0).animate(anim);
    super.initState();
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _passwordController.dispose();
    _passerController.dispose();
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

              //Button which is triggered when password is wrong
              AnimatedBuilder(
                animation:_buttonController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0.0, vibrateTranslate.value),
                    child: RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: theme.buttonColor,
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        ' Войти ',
                        style: TextStyle(
                            fontSize: 20.0,
                            letterSpacing: 1.0,
                            color: Colors.black),
                      ),
                      onPressed: _passerController.state == PasserState.ticking
                          ? null
                          : () {
                        if (_formKey.currentState.validate()) {
                          _authenticationBloc
                              .dispatch(LogIn(_passwordController.text));
                        } else {
                          countOfWrongPasswordEnters++;
                          _buttonController.forward();
                          
                          if (countOfWrongPasswordEnters == 3) {
                            _passerController.toggle();
                            countOfWrongPasswordEnters = 0;
                          }
                        }

                        _passwordController.clear();
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TimePasser(
                controller: _passerController,
                textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.red[400],
                    fontFamily: 'Neucha'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
