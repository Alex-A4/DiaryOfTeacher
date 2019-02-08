import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}


//Call when app is started
class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

//Call when user is trying to log in
class LogIn extends AuthenticationEvent {
  final String password;

  LogIn(this.password);

  @override
  String toString() => 'LoggedIn';
}

//Call when user is trying to sign out
class SignOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}

class PasswordEvent extends AuthenticationEvent {
  final String password;

  PasswordEvent(this.password);

  @override
  String toString() => 'PasswordBuilder';
}

//Call when user is trying to sign in
class SignIn extends AuthenticationEvent {
  @override
  String toString() => 'SignIn';
}