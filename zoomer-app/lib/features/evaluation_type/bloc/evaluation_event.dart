part of 'evaluation_bloc.dart';

@immutable
abstract class EvaluationEvent {}

class ExerciseWiseEvent extends EvaluationEvent {}

class StudentWiseEvent extends EvaluationEvent {}

class AddStudentEvent extends EvaluationEvent {}

class EvaluationAuthEvent extends EvaluationEvent {}

class StudentTapEvent extends EvaluationEvent {
  final String studentName;

  StudentTapEvent({required this.studentName});
}
