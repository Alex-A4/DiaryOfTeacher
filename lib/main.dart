import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/repository/UserRepository.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App(userRepository: UserRepository(),));
}