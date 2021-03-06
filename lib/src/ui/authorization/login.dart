import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/repository/UserRepository.dart';
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

  bool isTicking = false;

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

    _passerController.addListener(() {
      if (_passerController.state == PasserState.stopped) {
        isTicking = false;
        setState(() {});
      } else {
        isTicking = true;
        setState(() {});
      }
    });

    _buttonController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 40))
          ..addStatusListener((status) {
            if (countOfVibrates < 5) {
              if (status == AnimationStatus.completed) {
                countOfVibrates++;
                _buttonController.reverse();
              }
              if (status == AnimationStatus.dismissed) {
                countOfVibrates++;
                _buttonController.forward();
              }
            } else {
              if (status == AnimationStatus.dismissed ||
                  status == AnimationStatus.completed) countOfVibrates = 0;
            }
          });

    final anim =
        CurvedAnimation(parent: _buttonController, curve: Curves.linear);
    vibrateTranslate = Tween<double>(begin: 0.0, end: 5.0).animate(anim);
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
                      hintStyle: TextStyle(color: Colors.grey[350], fontSize: 20.0),
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
                animation: _buttonController,
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
                      onPressed: isTicking ? null : tryToLogIn,
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

  //Pushing vibration to enter button and check count of wrong enters
  void pushVibration() {
    countOfWrongPasswordEnters++;
    _buttonController.forward();

    if (countOfWrongPasswordEnters == 3) {
      _passerController.toggle();
      countOfWrongPasswordEnters = 0;
    }
  }

  //Trying to log in
  void tryToLogIn() {
    if (_formKey.currentState.validate()) {
      UserRepository.checkPasswordCorrect(_passwordController.text)
          .then((value) {
        if (value)
          _authenticationBloc.dispatch(LogIn(_passwordController.text));
        else
          pushVibration();
      });
    } else
      pushVibration();

    _passwordController.clear();
  }
}
