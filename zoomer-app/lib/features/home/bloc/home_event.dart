part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class NavigateEvent extends HomeEvent {
  final String grade;

  NavigateEvent({required this.grade});
}

class StudentsEvent extends HomeEvent {
  final String division;

  StudentsEvent({required this.division});
}

class FetchDivisionsEvent extends HomeEvent {
  final String grade;
  final String school;

  FetchDivisionsEvent({required this.grade, required this.school});
}
// New event to fetch grades and divisions
class FetchGradesAndDivisionsEvent extends HomeEvent {
  final String schoolName;

  FetchGradesAndDivisionsEvent({required this.schoolName});
}