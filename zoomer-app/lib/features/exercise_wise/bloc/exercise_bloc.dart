import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:msap/services/bluetooth.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc() : super(ExerciseInitial()) {
    on<StudentDetailsEvent>(_onStudentDetailsEvent);
    on<AbsentEvent>(_onAbsentEvent);
    on<PresentEvent>(_onPresentEvent);
    on<NavigateToAssessmentScreenEvent>(_onNavigateToAssessmentScreenEvent);
    on<NavigateToBandCallibrationScreenEvent>(
        _onNavigateToBandCallibrationScreenEvent);
    on<StartAssessmentEvent>(_onStartAssessmentEvent);
    on<StopAssessmentEvent>(_onStopAssessmentEvent);
    on<PauseAssessmentEvent>(_onPauseAssessmentEvent);
    on<ResumeAssessmentEvent>(_onResumeAssessmentEvent);
    on<AddStudentEvent>(_onAddStudentEvent);
    on<StudentTapEvent>(_onStudentTapEvent);
    on<AuthEvent>(_onAuthEvent);
    on<BluetoothScanEvent>(_onBluetoothScanEvent);
  }

  void _onAbsentEvent(AbsentEvent event, Emitter<ExerciseState> emit) async {
    emit(Absent());
  }

  void _onPresentEvent(PresentEvent event, Emitter<ExerciseState> emit) async {
    emit(Present());
  }

  void _onNavigateToBandCallibrationScreenEvent(
      NavigateToBandCallibrationScreenEvent event,
      Emitter<ExerciseState> emit) async {
    emit(NavigateToBandCallibrationScreen());
  }

  void _onNavigateToAssessmentScreenEvent(NavigateToAssessmentScreenEvent event,
      Emitter<ExerciseState> emit) async {
    emit(NavigateToAssessmentScreen());
  }

  void _onStartAssessmentEvent(
      StartAssessmentEvent event, Emitter<ExerciseState> emit) async {
    emit(StartAssessment());
  }

  void _onStopAssessmentEvent(
      StopAssessmentEvent event, Emitter<ExerciseState> emit) async {
    emit(StopAssessment());
  }

  void _onResumeAssessmentEvent(
      ResumeAssessmentEvent event, Emitter<ExerciseState> emit) async {
    emit(ResumeAssessment());
  }

  void _onPauseAssessmentEvent(
      PauseAssessmentEvent event, Emitter<ExerciseState> emit) async {
    emit(PauseAssessment());
  }

  void _onStudentDetailsEvent(
      StudentDetailsEvent event, Emitter<ExerciseState> emit) async {
    emit(StudentDetails());
  }

  void _onAddStudentEvent(
      AddStudentEvent event, Emitter<ExerciseState> emit) async {
    emit(AddStudent());
  }

  void _onStudentTapEvent(
      StudentTapEvent event, Emitter<ExerciseState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('student', event.studentName);
    var assessment = prefs.getString('assessment');

    if (assessment == 'AI') {
      emit(AIAssessment());
    } else {
      emit(ManualAssessment());
    }
  }

  void _onAuthEvent(AuthEvent event, Emitter<ExerciseState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? exerciseName = prefs.getString('exercise');
    String? grade = prefs.getString('grade');
    String? studentName = prefs.getString('student');
    emit(Auth(
      exerciseName: exerciseName!,
      grade: grade!,
      studentName: studentName,
    ));
  }

  void _onBluetoothScanEvent(
      BluetoothScanEvent event, Emitter<ExerciseState> emit) async {
    try {
      emit(ExerciseLoading());

      final BluetoothServices service = BluetoothServices();
      List<BluetoothDevice> devices = await service.scanDevices();
      emit(BluetoothScanComplete(devices: devices));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }
}
