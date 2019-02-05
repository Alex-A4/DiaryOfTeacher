import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_of_teacher/src/ui/authorization/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


//Screen to set password for user
class PasswordBuilder extends StatefulWidget {
  final String userID;

  PasswordBuilder(this.userID);

  _PasswordBuilderState createState() => _PasswordBuilderState(userID);
}

class _PasswordBuilderState extends State<PasswordBuilder> {
  final String userID;
  _PasswordBuilderState(this.userID);

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
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  elevation: 5.0,
                  child: Text(
                    'Сохранить',
                    style: TextStyle(fontSize: 20.0),
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
      Firestore.instance
          .collection('users')
          .document(userID)
          .updateData({
        'passwordHash': _passwordController.text.hashCode
      });

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