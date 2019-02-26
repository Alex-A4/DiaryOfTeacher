import 'package:bloc/bloc.dart';
import 'package:diary_of_teacher/src/repository/students_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'menu.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  @override
  MenuState get initialState => ProfileState();

  @override
  Stream<MenuState> mapEventToState(
      MenuState currentState, MenuEvent event) async* {
    if (event is LoadingEvent) {
      yield ProfileState();
    }

    //Opening Profile
    if (event is ProfileEvent) {
      yield ProfileState();
    }

    //Opening Schedule
    if (event is ScheduleEvent) {
      yield ScheduleState();
    }

    //Opening Students
    if (event is StudentsEvent) {
      yield StudentsState();
    }

    //Opening Lessons
    if (event is LessonsEvent) {
      yield LessonsState();
    }

    //Opening Timeout
    if (event is TimeoutEvent) {
      yield TimeoutState();
    }

    //Opening Settings
    if (event is SettingsEvent) {
      yield SettingsState();
    }
  }

  //Make the delay to close Drawer before screen change
  @override
  Stream<MenuEvent> transform(Stream<MenuEvent> events) {
    return (events as Observable<MenuEvent>)
        .debounce(Duration(milliseconds: 300));
  }

  //Writing transition to console
  @override
  void onTransition(Transition<MenuEvent, MenuState> transition) {
    print(transition);
  }
}
