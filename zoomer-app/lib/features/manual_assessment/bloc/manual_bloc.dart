import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:msap/services/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../services/golain_api_services.dart';
import 'package:get_it/get_it.dart';

import 'dart:developer';

part 'manual_event.dart';
part 'manual_state.dart';

class FetchStudentsEvent extends ManualEvent {
  final String schoolName;
  final String grade;
  final String division;

  FetchStudentsEvent(
      {required this.schoolName, required this.grade, required this.division});
}

class StudentsLoadedState extends ManualState {
  final List<String> students;

  StudentsLoadedState(this.students);
}

class ManualBloc extends Bloc<ManualEvent, ManualState> {
  static final getIt = GetIt.instance;
  final ImagePicker _picker = ImagePicker();

  final golainApiService = getIt<GolainApiService>();

  ManualBloc() : super(ManualInitial()) {
    on<FetchStudentsEvent>(_onFetchStudentsEvent);
    on<PresentEvent>(_onPresentEvent);
    on<AbsentEvent>(_onAbsentEvent);
    on<NextQuestionEvent>(_onNextQuestionEvent);
    on<PreviousQuestionEvent>(_onPreviousQuestionEvent);
    on<QuestionsEvent>(_onQuestionsEvent);
    on<EndQuestionsEvent>(_onEndQuestionsEvent);
    on<AuthEvent>(_onAuthEvent);
    on<StudentsTapEvent>(_onStudentsTapEvent);
    on<AddStudentEvent>(_onAddStudentEvent);
    on<StudentWiseEvent>(_onStudentWiseEvent);
    on<ExerciseWiseEvent>(_onExerciseWiseEvent);
    on<AllQuestionsCompletedEvent>(_onAllQuestionsCompletedEvent);

    on<ShowPopupEvent>((event, emit) async {
      // Wait for 10 seconds and then show popup
      await Future.delayed(const Duration(seconds: 10));
      emit(ShowPopupState());
    });

    on<PickImageEvent>((event, emit) async {
      try {
        // Pick an image using the camera
        final XFile? image =
            await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          // Upload the image to Firebase
          log("upload image firebase");
          final String imageUrl =
              await _uploadImageToFirebase(File(image.path));
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('image_id', imageUrl);
          emit(ImagePickedState(imageUrl));
        } else {
          log("upload failed state");
          emit(ImageUploadFailedState());
        }
      } catch (e) {
        log("image upload failed state");
        emit(ImageUploadFailedState());
      }
    });
  }

  void _onFetchStudentsEvent(
      FetchStudentsEvent event, Emitter<ManualState> emit) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hiveService = HiveService();

      if (connectivityResult == ConnectivityResult.none) {
        // No internet: fetch data from Hive
        final studentsData =
            await hiveService.getStudentData(event.grade, event.division);
        final studentNames = studentsData
            .map<String>((student) => student['student_name'] as String)
            .toList();

        log('Fetched student names from Hive for ${event.grade} ${event.division}: $studentNames');
        emit(StudentsLoadedState(studentNames));
      } else {
        // Internet available: fetch data from the API
        final studentsData = await golainApiService.getStudentList(
            event.schoolName, event.grade, event.division);

        final studentNames = studentsData
            .map<String>((student) => student['student_name'] as String)
            .toList();

        log('Fetched student names from API for ${event.grade} ${event.division}: $studentNames');

        // Save the fetched data in Hive for offline access
        await hiveService.saveStudentData(
            studentsData, event.grade, event.division);

        emit(StudentsLoadedState(studentNames));
      }
    } catch (e) {
      log('Failed to fetch students: $e');
      // emit(StudentsErrorState('Failed to fetch students: $e'));
    }
  }

  void _onPresentEvent(PresentEvent event, Emitter<ManualState> emit) async {
    emit(Present());
  }

  void _onAbsentEvent(AbsentEvent event, Emitter<ManualState> emit) async {
    emit(Absent());
  }

  // void _onNextQuestionEvent(
  //     NextQuestionEvent event, Emitter<ManualState> emit) async {
  //   emit(NextQuestion());
  // }
  // void _onNextQuestionEvent(
  //     NextQuestionEvent event, Emitter<ManualState> emit) async {
  //   final int totalQuestions = 6;

  //   if (event.currentIndex < totalQuestions - 1) {
  //     emit(NextQuestion());
  //   } else {
  //     emit(AllQuestionsCompletedState());
  //   }
  // }

  void _onNextQuestionEvent(
      NextQuestionEvent event, Emitter<ManualState> emit) async {
    final int totalQuestions = 6;

    if (event.currentIndex < totalQuestions - 1) {
      emit(NextQuestion());
    } else {
      emit(AllQuestionsCompletedState());
    }
  }

  void _onPreviousQuestionEvent(
      PreviousQuestionEvent event, Emitter<ManualState> emit) async {
    emit(PreviousQuestion());
  }

  void _onQuestionsEvent(
      QuestionsEvent event, Emitter<ManualState> emit) async {
    emit(Questions(attendance: event.attendance));
  }

  void _onEndQuestionsEvent(
      EndQuestionsEvent event, Emitter<ManualState> emit) async {
    emit(EndQuestions());
  }

  void _onAuthEvent(AuthEvent event, Emitter<ManualState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? grade = prefs.getString('grade');
    String? studentName = prefs.getString('student');
    String? division = prefs.getString('div');
    emit(Auth(
      grade: grade!,
      studentName: studentName,
      division: division!,
    ));

    String? type = prefs.getString('type');
    if (type == 'e') {
      emit(ExerciseWise());
    } else {
      emit(StudentWise());
    }
  }

  void _onStudentsTapEvent(
      StudentsTapEvent event, Emitter<ManualState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('student', event.studentName);
    log('Student Name: ${event.studentName}');
    emit(StudentsTap());
  }

  void _onAddStudentEvent(
      AddStudentEvent event, Emitter<ManualState> emit) async {
    emit(AddStudent());
  }

  void _onStudentWiseEvent(
      StudentWiseEvent event, Emitter<ManualState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', 's');
    emit(StudentWise());
  }

  void _onExerciseWiseEvent(
      ExerciseWiseEvent event, Emitter<ManualState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', 'e');
    emit(ExerciseWise());
  }

// upload image to firebase
  Future<String> _uploadImageToFirebase(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(const Uuid().v1())
          .child('uploads/${DateTime.now().toIso8601String()}.png');
      final uploadTask = await storageRef.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      log("failed to upload image firebase");
      throw Exception('Failed to upload image');
    }
  }

  void _onAllQuestionsCompletedEvent(
      AllQuestionsCompletedEvent event, Emitter<ManualState> emit) async {
    emit(AllQuestionsCompletedState());
  }
}
