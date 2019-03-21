import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


//Screen to set password for user
class PasswordBuilder extends StatefulWidget {
  _PasswordBuilderState createState() => _PasswordBuilderState();
}

class _PasswordBuilderState extends State<PasswordBuilder> {
  //For building password
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
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
                  onPressed: (){
                    if (_formKey.currentState.validate()) {
                      _authenticationBloc.dispatch(PasswordEvent(_passwordController.text));
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}