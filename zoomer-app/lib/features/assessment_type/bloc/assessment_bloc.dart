import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  AssessmentBloc() : super(AssessmentInitial()) {
    on<AIAssessmentEvent>(_onAIAssessmentEvent);
    on<ManualAssessmentEvent>(_onManualAssessmentEvent);
  }

  void _onAIAssessmentEvent(
      AIAssessmentEvent event, Emitter<AssessmentState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('assessment', 'AI');
    emit(AIAssessment());
  }

  void _onManualAssessmentEvent(
      ManualAssessmentEvent event, Emitter<AssessmentState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('assessment', 'Manual');
    emit(ManualAssessment());
  }
}
