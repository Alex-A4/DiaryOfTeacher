import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable{}

//If user Uninitialized then need to signIn by google
class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}


//If user Authenticated then he is ready to work
class AuthenticationAuthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationAuthenticated';
}


//If user Unauthenticated then need to LogIn by password
class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

//If Loading then need show CircularIndicator
class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';
}


//If Error happens then need to show FlutterToast
class AuthenticationError extends AuthenticationState {
  final String error;

  AuthenticationError(@required this.error);

  @override
  String toString() => 'AuthenticationError $error';
}