part of 'manual_bloc.dart';

@immutable
abstract class ManualState {}

class ManualInitial extends ManualState {}

class ManualLoading extends ManualState {}

class Present extends ManualState {}

class Absent extends ManualState {}

class NextQuestion extends ManualState {}

class PreviousQuestion extends ManualState {}

class Questions extends ManualState {
  final String attendance;

  Questions({required this.attendance});
}

class EndQuestions extends ManualState {}

class Auth extends ManualState {
  final String grade;
  final String? studentName;
  final String division;

  Auth({
    required this.grade,
    required this.studentName,
    required this.division,
  });
}

class StudentsTap extends ManualState {}

class AddStudent extends ManualState {}

class ExerciseWise extends ManualState {}

class StudentWise extends ManualState {}

class InitialState extends ManualState {}

class ShowPopupState extends ManualState {}

class ImagePickedState extends ManualState {
  final String imageUrl;
  ImagePickedState(this.imageUrl);
}

class ImageUploadFailedState extends ManualState {}

class AllQuestionsCompletedState extends ManualState {}

