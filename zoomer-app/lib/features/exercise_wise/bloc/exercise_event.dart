part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseEvent {}

class StudentDetailsEvent extends ExerciseEvent {}

class AbsentEvent extends ExerciseEvent {}

class PresentEvent extends ExerciseEvent {}

class StartAssessmentEvent extends ExerciseEvent {}

class PauseAssessmentEvent extends ExerciseEvent {}

class ResumeAssessmentEvent extends ExerciseEvent {}

class StopAssessmentEvent extends ExerciseEvent {}

class NavigateToBandCallibrationScreenEvent extends ExerciseEvent {}

class NavigateToAssessmentScreenEvent extends ExerciseEvent {}

class AddStudentEvent extends ExerciseEvent {}

class AuthEvent extends ExerciseEvent {}

class StudentTapEvent extends ExerciseEvent {
  final String studentName;

  StudentTapEvent({required this.studentName});
}

class BluetoothScanEvent extends ExerciseEvent {}
