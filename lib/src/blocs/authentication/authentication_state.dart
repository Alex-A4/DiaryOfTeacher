import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable{}

//When app is loading, hide another UI
class AuthenticationStartApp extends AuthenticationState {
  @override
  String toString() => 'AuthenticationStartApp';
}

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

class AuthenticationPassword extends AuthenticationState {

  @override
  String toString() => 'AuthenticationPasswordBuilder';
}