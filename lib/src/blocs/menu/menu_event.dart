import 'package:equatable/equatable.dart';


abstract class MenuEvent extends Equatable{}

class ProfileEvent extends MenuEvent {
  @override
  String toString() => 'ProfileEvent';
}

class ScheduleEvent extends MenuEvent {
  @override
  String toString() => 'ScheduleEvent';
}

class StudentsEvent extends MenuEvent {
  @override
  String toString() => 'StudentsEvent';
}

class LessonsEvent extends MenuEvent {
  @override
  String toString() => 'LessonsEvent';
}

class TimeoutEvent extends MenuEvent {
  @override
  String toString() => 'TimeoutEvent';
}

class SettingsEvent extends MenuEvent {
  @override
  String toString() => 'SettingsEvent';
}