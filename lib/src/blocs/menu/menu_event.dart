import 'package:equatable/equatable.dart';


abstract class MenuEvent extends Equatable{}

class Profile extends MenuEvent {
  @override
  String toString() => 'Profile';
}

class Schedule extends MenuEvent {
  @override
  String toString() => 'Schedule';
}

class Students extends MenuEvent {
  @override
  String toString() => 'Students';
}

class Lessons extends MenuEvent {
  @override
  String toString() => 'Lessons';
}

class Timeout extends MenuEvent {
  @override
  String toString() => 'Timeout';
}

class Settings extends MenuEvent {
  @override
  String toString() => 'Settings';
}