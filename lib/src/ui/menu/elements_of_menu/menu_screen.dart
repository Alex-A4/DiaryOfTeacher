import 'package:diary_of_teacher/src/blocs/menu/menu.dart';
import 'package:diary_of_teacher/src/ui/menu/lessons_screen.dart';
import 'package:diary_of_teacher/src/ui/menu/profile_screen.dart';
import 'package:diary_of_teacher/src/ui/menu/schedule_screen.dart';
import 'package:diary_of_teacher/src/ui/menu/settings_screen.dart';
import 'package:diary_of_teacher/src/ui/menu/students_screen.dart';
import 'package:diary_of_teacher/src/ui/menu/timeout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MenuScreen extends StatefulWidget {
  _MenuScreenState createState() => _MenuScreenState();
}


class _MenuScreenState extends State<MenuScreen> {
  MenuBloc _menuBloc;

  @override
  void initState() {
    _menuBloc = MenuBloc();
    _menuBloc.dispatch(LoadingEvent());
    super.initState();
  }


  @override
  void dispose() {
    _menuBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuBloc>(
      bloc: _menuBloc,
      child: BlocBuilder(
        bloc: _menuBloc,
        builder: (context, MenuState state) {
          if (state is LoadingState) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is ProfileState) {
            return ProfileScreen();
          }

          if (state is ScheduleState) {
            return ScheduleScreen();
          }

          if (state is StudentsState) {
            return StudentsScreen();
          }

          if (state is LessonsState) {
            return LessonsScreen();
          }

          if (state is TimeoutState) {
            return TimeoutScreen();
          }

          if (state is SettingsState) {
             return SettingsScreen();
          }
        },
      ),
    );
  }
}