part of 'evaluation_bloc.dart';

@immutable
abstract class EvaluationState {}

class EvaluationInitial extends EvaluationState {}

class ExerciseWise extends EvaluationState {}

class StudentWise extends EvaluationState {}

class AddStudent extends EvaluationState {}

class EvaluationAuth extends EvaluationState {
  final String grade;

  EvaluationAuth({required this.grade});
}

class StudentTap extends EvaluationState {}

class AIAssessment extends EvaluationState {}

class ManualAssessment extends EvaluationState {}
