part of 'manual_bloc.dart';

@immutable
abstract class ManualEvent {}

class PresentEvent extends ManualEvent {}

class AbsentEvent extends ManualEvent {}

class NextQuestionEvent extends ManualEvent {
  final int currentIndex;

  NextQuestionEvent({required this.currentIndex});
}

class PreviousQuestionEvent extends ManualEvent {}

class QuestionsEvent extends ManualEvent {
  final String attendance;

  QuestionsEvent({required this.attendance});
}

class EndQuestionsEvent extends ManualEvent {}

class AuthEvent extends ManualEvent {}

class StudentsTapEvent extends ManualEvent {
  final String studentName;

  StudentsTapEvent({required this.studentName});
}

class AddStudentEvent extends ManualEvent {}

class ExerciseWiseEvent extends ManualEvent {}

class StudentWiseEvent extends ManualEvent {}

class ShowPopupEvent extends ManualEvent {}

class PickImageEvent extends ManualEvent {}

class AllQuestionsCompletedEvent extends ManualEvent {}
