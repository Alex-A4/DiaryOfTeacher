import 'package:bloc/bloc.dart';
import 'package:diary_of_teacher/src/blocs/authentication/authentication.dart';
import 'package:diary_of_teacher/src/repository/UserRepository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc(this.userRepository);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState currentState, AuthenticationEvent event) async*{
    if (event is AppStarted) {
      bool isLogged = await userRepository.isLoggedIn();

      //If user exist in memory then notify user to write password
      if (isLogged) {
        yield AuthenticationUnauthenticated();
      } else {
        //If user not exist then notify user to signin
        yield AuthenticationUninitialized();
      }
    }

    //If user is trying to sign in
    if (event is SignIn) {
      try {
        await userRepository.handleSignIn();
        yield AuthenticationUnauthenticated();
      } catch(error){
        yield AuthenticationError(error);
      }
    }

    //If user trying to log in
    if (event is LogIn) {
      try {
        await userRepository.handleLogin(event.password);
        yield AuthenticationAuthenticated();
      } catch(error) {
        yield AuthenticationError(error);
      }
    }

    //If user trying to sign out
    if (event is SignOut) {
      await userRepository.handleSignOut();
      yield AuthenticationUninitialized();
    }
  }
}
