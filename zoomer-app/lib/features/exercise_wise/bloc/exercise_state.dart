part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class Absent extends ExerciseState {}

class Present extends ExerciseState {}

class ExerciseError extends ExerciseState {
  final String error;

  ExerciseError(this.error);
}

class StudentDetails extends ExerciseState {}

class StartAssessment extends ExerciseState {}

class PauseAssessment extends ExerciseState {}

class ResumeAssessment extends ExerciseState {}

class StopAssessment extends ExerciseState {}

class NavigateToBandCallibrationScreen extends ExerciseState {}

class NavigateToAssessmentScreen extends ExerciseState {}

class AddStudent extends ExerciseState {}

class Auth extends ExerciseState {
  final String exerciseName;
  final String grade;
  final String? studentName;

  Auth({
    required this.exerciseName,
    required this.grade,
    required this.studentName,
  });
}

class AIAssessment extends ExerciseState {}

class ManualAssessment extends ExerciseState {}

class BluetoothScanComplete extends ExerciseState {
  final List<BluetoothDevice> devices;

  BluetoothScanComplete({required this.devices});
}

class ConnectDisconnect extends ExerciseState {
  final BluetoothDevice device;

  ConnectDisconnect({required this.device});
}
