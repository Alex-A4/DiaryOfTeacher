import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/repository/UserRepository.dart';
import 'package:diary_of_teacher/src/ui/authorization/login.dart';
import 'package:diary_of_teacher/src/ui/authorization/password_builder.dart';
import 'package:diary_of_teacher/src/ui/menu/menu_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'ui/authorization/sign_in.dart';

//Start's point of the app
class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;

  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diary of teacher',
        theme: theme,
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationStartApp) {
              return Container(
                color: Colors.white,
              );
            }

            if (state is AuthenticationUninitialized) {
              return SignInScreen();
            }

            if (state is AuthenticationAuthenticated) {
              return MenuScreen();
            }

            if (state is AuthenticationUnauthenticated) {
              return LogInScreen();
            }

            if (state is AuthenticationPassword) {
              return PasswordBuilder();
            }
          },
        ),
      ),
    );
  }
}

final theme = ThemeData(
  primaryColor: Color(0xFFFFDEE0),
  accentColor: Color(0xFFFDF5E6),
  cursorColor: Color(0xFF9FDFDF),
  textSelectionColor: Color(0xFF9FDFDF),
  buttonColor: Color(0xFFFFE4E1),
  hintColor: Colors.black,
  textTheme: TextTheme(
    //For TextField
    body1: TextStyle(color: Colors.black, fontSize: 23.0, letterSpacing: 5.0),
    //For button's text
    body2: TextStyle(color: Colors.black, fontSize: 20.0, letterSpacing: 1.0),
    //For Text widgets in menu
    display1:
        TextStyle(color: Colors.black, fontSize: 18.0, letterSpacing: 0.0),
    //For text in ListTile
    display2: TextStyle(color: Colors.black, fontSize: 17.0),
    display3: TextStyle(color: Colors.black54, fontSize: 14.0, letterSpacing: 0.0),
  ),
);
