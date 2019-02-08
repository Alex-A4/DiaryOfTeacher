import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:diary_of_teacher/src/ui/authorization/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


//Screen to set password for user
class PasswordBuilder extends StatefulWidget {
  _PasswordBuilderState createState() => _PasswordBuilderState();
}

class _PasswordBuilderState extends State<PasswordBuilder> {
  //For building password
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void initState() {
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
        title: Text('Придумайте пароль'),
      ),
      body: ListView(
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
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  elevation: 5.0,
                  color: theme.buttonColor,
                  child: Text(
                    'Сохранить',
                    style: theme.textTheme.body2,
                  ),
                  onPressed: tryToSave,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void tryToSave() async {
    if (_formKey.currentState.validate()) {
      SharedPreferences prefs =
      await SharedPreferences.getInstance();
      //Writing hashcode of password to stores

      if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
        Firestore.instance
            .collection('users')
            .document(User.user.uid)
            .updateData({
          'passwordHash': _passwordController.text.hashCode
        });
      }

      prefs.setInt(
          'passwordHash', _passwordController.text.hashCode);

      print(
          'PasswordHash: ${_passwordController.text.hashCode}');

      Fluttertoast.showToast(
          msg: 'Пароль сохранён',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.black);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LogIn()));
    }
  }
}