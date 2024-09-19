import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'evaluation_event.dart';
part 'evaluation_state.dart';

class EvaluationBloc extends Bloc<EvaluationEvent, EvaluationState> {
  EvaluationBloc() : super(EvaluationInitial()) {
    on<ExerciseWiseEvent>(_onExerciseWiseEvent);
    on<StudentWiseEvent>(_onStudentWiseEvent);
    on<AddStudentEvent>(_onAddStudentEvent);
    on<EvaluationAuthEvent>(_onEvaluationAuthEvent);
    on<StudentTapEvent>(_onStudentTapEvent);
  }

  void _onExerciseWiseEvent(
      ExerciseWiseEvent event, Emitter<EvaluationState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', 'e');
    emit(ExerciseWise());
  }

  void _onStudentWiseEvent(
      StudentWiseEvent event, Emitter<EvaluationState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', 's');
    await prefs.remove('student');
    emit(StudentWise());
  }

  void _onAddStudentEvent(
      AddStudentEvent event, Emitter<EvaluationState> emit) async {
    emit(AddStudent());
  }

  void _onEvaluationAuthEvent(
      EvaluationAuthEvent event, Emitter<EvaluationState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? grade = prefs.getString('grade');
    emit(EvaluationAuth(grade: grade!));

    String? type = prefs.getString('type');
    if (type == 's') {
      emit(StudentWise());
    } else {
      emit(ExerciseWise());
    }
  }

  void _onStudentTapEvent(
      StudentTapEvent event, Emitter<EvaluationState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('student', event.studentName);
    var assessment = prefs.getString('assessment');

    if (assessment == 'AI') {
      emit(AIAssessment());
    } else {
      emit(ManualAssessment());
    }
  }
}
