import 'package:diary_of_teacher/src/ui/main/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  _LogIn createState() => _LogIn();
}

class _LogIn extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  var _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
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
                    style: TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 5.0,
                    ),
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
                color: Color(0xFFFFE4E1),
                child: Text(
                  'Проверить',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: handleLogin,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> handleLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int hash = prefs.getInt('passwordHash');

    //If password if correct
    if (_passwordController.text.hashCode == hash) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => WelcomeScreen(
              prefs.getString('id'), prefs.getString('photoUrl'))));
    } else {
      Fluttertoast.showToast(msg: 'Пароль неверный');
      _passwordController.clear();
    }
  }
}
