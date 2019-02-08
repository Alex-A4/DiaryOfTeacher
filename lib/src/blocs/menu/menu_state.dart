import 'package:equatable/equatable.dart';


abstract class MenuState extends Equatable{}

class ProfileState extends MenuState {
  @override
  String toString() => 'ProfileState';
}

class ScheduleState extends MenuState {
  @override
  String toString() => 'ScheduleState';
}

class StudentsState extends MenuState {
  @override
  String toString() => 'StudentsState';
}

class LessonsState extends MenuState {
  @override
  String toString() => 'LessonsState';
}

class TimeoutState extends MenuState {
  @override
  String toString() => 'TimeoutState';
}

class SettingsState extends MenuState {
  @override
  String toString() => 'SettingsState';
}