part of 'student_bloc.dart';

@immutable
abstract class StudentEvent {}

class PresentEvent extends StudentEvent {}

class AbsentEvent extends StudentEvent {}
