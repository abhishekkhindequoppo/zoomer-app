import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial()) {
    on<AbsentEvent>(_onAbsentEvent);
    on<PresentEvent>(_onPresentEvent);
  }

  void _onAbsentEvent(AbsentEvent event, Emitter<StudentState> emit) async {
    emit(Absent());
  }

  void _onPresentEvent(PresentEvent event, Emitter<StudentState> emit) async {
    emit(Present());
  }
}
