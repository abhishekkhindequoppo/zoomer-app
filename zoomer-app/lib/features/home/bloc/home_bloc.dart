import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/golain_api_services.dart'; // Import your API service

part 'home_event.dart';
part 'home_state.dart';

class GradeDivisionSelected extends HomeState {
  final String grade;
  final String division;

  GradeDivisionSelected({required this.grade, required this.division});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GolainApiService apiService;

  HomeBloc({required this.apiService}) : super(HomeInitial()) {
    on<NavigateEvent>(_onNavigateEvent);
    on<StudentsEvent>(_onStudentsEvent);
    on<FetchDivisionsEvent>(_onFetchDivisionsEvent);
    on<FetchGradesAndDivisionsEvent>(_onFetchGradesAndDivisionsEvent); // New event
  }

  void _onNavigateEvent(NavigateEvent event, Emitter<HomeState> emit) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('grade', event.grade);
  // Emit the selected grade
  emit(GradeDivisionSelected(grade: event.grade, division: '')); // No division selected yet
  emit(Navigate());
}

  void _onStudentsEvent(StudentsEvent event, Emitter<HomeState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('div', event.division);

    String? a = prefs.getString('assessment');
    if (a == 'AI') {
      emit(AIAssessment());
    } else {
      emit(ManualAssessment());
    }
  }

  void _onFetchDivisionsEvent(FetchDivisionsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final data = await apiService.getGradesAndDivisions(event.school);
      List<String> divisions = data['data']
          .where((item) => item['grade'] == event.grade)
          .map<String>((item) => item['division'] as String)
          .toList();

      divisions.sort();

      emit(DivisionsLoaded(divisions: divisions));
    } catch (e) {
      emit(HomeError("Failed to fetch divisions"));
    }
  }

  // New function to handle fetching grades and divisions
  void _onFetchGradesAndDivisionsEvent(FetchGradesAndDivisionsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // Fetch grades and divisions from the API
      final data = await apiService.getGradesAndDivisions(event.schoolName);

      // Emit the state with the fetched data
      emit(GradesAndDivisionsLoaded(grades: data['grades']!, divisions: data['divisions']!));
    } catch (e) {
      emit(HomeError("Failed to fetch grades and divisions. Please log out and check your school name again."));
    }
  }
}
