import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'menu.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  @override
  MenuState get initialState => ProfileState();

  @override
  Stream<MenuState> mapEventToState(
      MenuState currentState, MenuEvent event) async* {
    //Opening Profile
    if (event is Profile) {
      yield ProfileState();
    }

    //Opening Schedule
    if (event is Schedule) {
      yield ScheduleState();
    }

    //Opening Students
    if (event is Students) {
      yield StudentsState();
    }

    //Opening Lessons
    if (event is Lessons) {
      yield LessonsState();
    }

    //Opening Timeout
    if (event is Timeout) {
      yield TimeoutState();
    }

    //Opening Settings
    if (event is Settings) {
      yield SettingsState();
    }
  }

  //Make the delay to close Drawer before screen change
  @override
  Stream<MenuEvent> transform(Stream<MenuEvent> events) {
    return (events as Observable<MenuEvent>)
        .debounce(Duration(milliseconds: 500));
  }

  //Writing transition to console
  @override
  void onTransition(Transition<MenuEvent, MenuState> transition) {
    print(transition);
  }
}
