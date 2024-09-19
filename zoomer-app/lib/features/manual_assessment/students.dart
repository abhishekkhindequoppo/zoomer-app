import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/manual_assessment/add_student.dart';
import 'package:msap/features/manual_assessment/bloc/manual_bloc.dart';
import 'package:msap/features/manual_assessment/manual_evaluation_type.dart';
import 'package:msap/features/manual_assessment/student_details.dart';
import 'package:msap/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:msap/services/golain_api_services.dart';

class ManualStudentsList extends StatefulWidget {
  final String exerciseName;

  const ManualStudentsList({super.key, this.exerciseName = ''});

  @override
  State<ManualStudentsList> createState() => _ManualStudentsListState();
}

class _ManualStudentsListState extends State<ManualStudentsList> {
  late ManualBloc _manualBloc;
  List<Map<String, dynamic>> evaluatedStudentDatas = [];
  List<String> parsedStudentNames = [];
  late String selectedGrade = 'Nursery';
  late String schoolName = 'Unknown School';
  late String selectedDivision = 'A';
  static final getIt = GetIt.instance;
  Set<String> studentSet = {};
  Map<String, int> studentExerciseCount = {};
  List<String> checklistStudentNames = [];
  String exerciseName = '';

  final golainApiService = getIt<GolainApiService>();

  @override
  void initState() {
    super.initState();
    _manualBloc = ManualBloc();
    _loadPreferencesAndFetchData();
  }

  Future<void> _loadPreferencesAndFetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedGrade = prefs.getString('selectedGrade') ?? 'Nursery';
      selectedDivision = prefs.getString('selectedDivision') ?? 'A';
      schoolName = prefs.getString('school_name') ?? 'Unknown School';
      exerciseName = prefs.getString('exercise') ?? '';
    });

    evaluatedStudentDatas = await golainApiService.getChecklistStudents(
        schoolName, selectedGrade, selectedDivision, 1);

    processStudentData();

    _manualBloc.add(FetchStudentsEvent(
      schoolName: schoolName,
      grade: selectedGrade,
      division: selectedDivision,
    ));
  }

  void processStudentData() {
    if (exerciseName.isEmpty) {
      for (var studentData in evaluatedStudentDatas) {
        String studentName = studentData['student_name'];
        studentSet.add(studentName);
        studentExerciseCount[studentName] = 0;

        if (studentData['attendance'] == 'Present') {
          Map<String, int> gradeExercises =
              Utils.gradeQuestionType[selectedGrade] ?? {};

          for (var exercise in gradeExercises.keys) {
            String apiField = questionToApiFieldMap[exercise] ?? '';
            if (apiField.isNotEmpty) {
              var value = studentData[apiField];
              log('Student name: $studentName, API Field: $apiField, Value: $value');
              if (value != 0 && value != '') {
                studentExerciseCount[studentName] =
                    (studentExerciseCount[studentName] ?? 0) + 1;
              }
            }
          }

          if (studentExerciseCount[studentName] == 6) {
            checklistStudentNames.add(studentName);
          }
        }
      }
    } else {
      for (var studentData in evaluatedStudentDatas) {
        String studentName = studentData['student_name'];
        studentSet.add(studentName);
        studentExerciseCount[studentName] = 0;

        if (studentData['attendance'] == 'Present') {
          String apiField = questionToApiFieldMap[exerciseName] ?? '';
          if (apiField.isNotEmpty) {
            var value = studentData[apiField];
            log('Student name: $studentName, API Field: $apiField, Value: $value');
            if (value != 0 && value != '') {
              studentExerciseCount[studentName] =
                  (studentExerciseCount[studentName] ?? 0) + 1;
            }
          }

          if (studentExerciseCount[studentName]! >= 1) {
            checklistStudentNames.add(studentName);
          }
        }
      }
    }
    log('Checklist Student Names: $checklistStudentNames');
  }

  @override
  void dispose() {
    _manualBloc.close();
    super.dispose();
  }

  void navigate() async {
    log('Exercise Name: ${exerciseName}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailsScreen(exerciseName: exerciseName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: utils.paddingHorizontal,
            vertical: utils.paddingVertical,
          ),
          child: BlocConsumer<ManualBloc, ManualState>(
            bloc: _manualBloc,
            listener: (context, state) {
              if (state is AddStudent) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddStudentForm(),
                  ),
                );
              } else if (state is StudentsTap) {
                navigate();
              }
            },
            builder: (context, state) {
              if (state is StudentsLoadedState) {
                parsedStudentNames = state.students;
                // log('Parsed Student Names: $parsedStudentNames');
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ManualEvaluationType(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: utils.titleSize,
                            ),
                          ),
                          SizedBox(width: utils.screenWidth * 0.02),
                          Text(
                            'Select a Student',
                            style: GoogleFonts.roboto(
                              fontSize: utils.subtitleSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          _manualBloc.add(AddStudentEvent());
                        },
                        icon: ImageIcon(
                          const AssetImage('assets/icons/add_circle.png'),
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          size: utils.subtitleSize * 1.5,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  Expanded(
                    child: ListView.separated(
                      itemCount: parsedStudentNames.length,
                      itemBuilder: (context, index) {
                        final isInFetchedList = checklistStudentNames
                            .contains(parsedStudentNames[index]);
                        return ListTile(
                          onTap: () {
                            _manualBloc.add(StudentsTapEvent(
                                studentName: parsedStudentNames[index]));
                          },
                          title: Row(
                            children: [
                              if (isInFetchedList)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: utils.subtitleSize * 1.2,
                                ),
                              SizedBox(
                                  width: isInFetchedList
                                      ? utils.screenWidth * 0.02
                                      : 0),
                              Expanded(
                                child: Text(
                                  parsedStudentNames[index],
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: utils.subtitleSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(thickness: utils.screenHeight * 0.001);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
