part of 'student_bloc.dart';

@immutable
abstract class StudentState {}

class StudentInitial extends StudentState {}

class Absent extends StudentState {}

class Present extends StudentState {}
