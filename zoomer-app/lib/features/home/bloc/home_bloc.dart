import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:msap/services/hive_service.dart';
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
    on<FetchGradesAndDivisionsEvent>(
        _onFetchGradesAndDivisionsEvent); // New event
  }

  void _onNavigateEvent(NavigateEvent event, Emitter<HomeState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('grade', event.grade);
    // Emit the selected grade
    emit(GradeDivisionSelected(
        grade: event.grade, division: '')); // No division selected yet
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

  

  void _onFetchDivisionsEvent(
      FetchDivisionsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final connectivityResult = await Connectivity().checkConnectivity();
    final hiveService = HiveService();

    try {
      // Check if the internet is available
      if (connectivityResult == ConnectivityResult.none) {
        // No internet, get data from Hive
        final hiveData = await hiveService.getGradesAndDivisionsFromHive();
        List<String> divisions = hiveData['data']
            .where((item) => item['grade'] == event.grade)
            .map<String>((item) => item['division'] as String)
            .toList();

        divisions.sort();
        log('Fetched data from Hive: $divisions');
        emit(DivisionsLoaded(divisions: divisions));
      } else {
        // Internet is available, fetch data from API
        final data = await apiService.getGradesAndDivisions(event.school);
        List<String> divisions = data['data']
            .where((item) => item['grade'] == event.grade)
            .map<String>((item) => item['division'] as String)
            .toList();

        divisions.sort();
        log('Fetched data from API: $divisions');

        // Save the fetched data to Hive for offline use
        await hiveService.saveGradesAndDivisions(
          data['grades'],
          divisions,
          data['data'],
        );

        emit(DivisionsLoaded(divisions: divisions));
      }
    } catch (e) {
      emit(HomeError("Failed to fetch divisions"));
    }
  }


  void _onFetchGradesAndDivisionsEvent(
      FetchGradesAndDivisionsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      // Check network connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected) {
        // Network is available, fetch data from the API
        final data = await apiService.getGradesAndDivisions(event.schoolName);

        // Store the fetched data in Hive for offline use
        var box = await Hive.openBox('gradesDivisionsBox');
        await box.put('grades', data['grades']);
        log(
          " home bloc from api grade:${box.put('grades', data['grades'])}",
        );
        await box.put('divisions', data['divisions']);
        log(
          " home bloc from api divisions:${box.put('divisions', data['divisions'])}",
        );

        // Emit the state with the fetched data
        emit(GradesAndDivisionsLoaded(
          grades: data['grades']!,
          divisions: data['divisions']!,
        ));
      } else {
        // No network, fetch data from Hive
        var box = await Hive.openBox('gradesDivisionsBox');
        final grades = box.get('grades');
        log(" home bloc from hive grades:${box.get('grades')}");
        final divisions = box.get('divisions');
        log(" home bloc from hive divisions:${box.get('divisions')}");

        if (grades != null && divisions != null) {
          // Emit the state with the data from Hive
          emit(GradesAndDivisionsLoaded(
            grades: grades,
            divisions: divisions,
          ));
        } else {
          // No data available in Hive
          emit(HomeError(
              "No internet connection and no offline data available."));
        }
      }
    } catch (e) {
      // Emit an error state if something goes wrong
      emit(HomeError("Please restart the app."));
    }
  }
}
