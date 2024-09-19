part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class Navigate extends HomeState {}

class AIAssessment extends HomeState {}

class ManualAssessment extends HomeState {}

// New state to represent the loading process
class HomeLoading extends HomeState {}

// New state to hold fetched grades and divisions
class GradesAndDivisionsLoaded extends HomeState {
  final List<String> grades;
  final List<String> divisions;

  GradesAndDivisionsLoaded({required this.grades, required this.divisions});
}

class DivisionsLoaded extends HomeState {
  final List<String> divisions;

  DivisionsLoaded({required this.divisions});
}

// State to handle errors
class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
