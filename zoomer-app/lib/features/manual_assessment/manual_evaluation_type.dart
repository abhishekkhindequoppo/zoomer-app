import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/home/divisions.dart';
import 'package:msap/features/manual_assessment/add_student.dart';
import 'package:msap/features/manual_assessment/bloc/manual_bloc.dart';
import 'package:msap/features/manual_assessment/student_details.dart';
import 'package:msap/features/manual_assessment/students.dart';
import 'package:msap/features/profile/profile.dart';
import 'package:msap/utils.dart';
import 'package:msap/widgets/exercise_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:msap/services/golain_api_services.dart';

class ManualEvaluationType extends StatefulWidget {
  const ManualEvaluationType({super.key});

  @override
  State<ManualEvaluationType> createState() => _ManualEvaluationTypeState();
}

class _ManualEvaluationTypeState extends State<ManualEvaluationType> {
  String division = '';
  String grade = '';
  List<String> parsedStudentNames = [];
  List<Map<String, dynamic>> evaluatedStudentDatas = [];
  late String selectedGrade = 'Nursery';
  late String selectedDivision = 'A';
  late String schoolName = 'Unknown School';
  late ManualBloc _manualBloc;
  final map = Utils.gradeQuestionType;
  Set<String> studentSet = {};
  Map<String, int> studentExerciseCount = {};
  List<String> checklistStudentNames = [];

  Map<String, List<String>> exerciseConfigs = Utils.exerciseConfigs;

  static final getIt = GetIt.instance;

  final golainApiService = getIt<GolainApiService>();

  @override
  void initState() {
    super.initState();
    _manualBloc = ManualBloc();
    _loadPreferencesAndFetchData(); // Load preferences and then fetch data
  }

  Future<void> _loadPreferencesAndFetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('exercise');
    setState(() {
      selectedGrade = prefs.getString('selectedGrade') ?? 'Nursery';
      selectedDivision = prefs.getString('selectedDivision') ?? 'A';
      schoolName = prefs.getString('school_name') ?? 'Unknown School';
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
    log('Processing Student Data');
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

    log('Checklist Student Names: $checklistStudentNames');
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
              if (state is Auth) {
                setState(() {
                  division = state.division;
                  grade = state.grade;
                });
              } else if (state is AddStudent) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddStudentForm(),
                  ),
                );
              } else if (state is StudentsTap) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentDetailsScreen(),
                  ),
                );
              } else if (state is StudentsLoadedState) {
                // Parsing the students list
                setState(() {
                  parsedStudentNames = state.students;
                  // log('Parsed student names: $parsedStudentNames');
                });
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  builder: (context) => DivisionsScreen(
                                      selectedGrade: selectedGrade),
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
                            division,
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: utils.titleSize,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.settings,
                          size: utils.iconSize,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  Text(
                    'Evaluation Type',
                    style: GoogleFonts.roboto(
                      fontSize: utils.subtitleSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _manualBloc.add(ExerciseWiseEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state is ExerciseWise
                              ? utils.selectedContainer
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: state is ExerciseWise
                                ? BorderSide.none
                                : const BorderSide(color: Color(0xFF1E3D75)),
                            borderRadius:
                                BorderRadius.circular(utils.borderRadius),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: utils.paddingHorizontal,
                            vertical: utils.paddingVertical,
                          ),
                        ),
                        child: Text(
                          'Exercise Wise',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFF1E3D75),
                            fontWeight: FontWeight.w400,
                            fontSize: utils.subtitleSize * 0.7,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _manualBloc.add(StudentWiseEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state is StudentWise
                              ? utils.selectedContainer
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: state is StudentWise
                                ? BorderSide.none
                                : const BorderSide(color: Color(0xFF1E3D75)),
                            borderRadius:
                                BorderRadius.circular(utils.borderRadius),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: utils.paddingHorizontal,
                            vertical: utils.paddingVertical,
                          ),
                        ),
                        child: Text(
                          'Student Wise',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFF1E3D75),
                            fontWeight: FontWeight.w400,
                            fontSize: utils.subtitleSize * 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  if (state is ExerciseWise) ...[
                    Text(
                      'Exercises',
                      style: GoogleFonts.roboto(
                        fontSize: utils.subtitleSize * 0.9,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: utils.screenHeight * 0.03),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: utils.screenWidth * 0.03,
                          mainAxisSpacing: utils.screenHeight * 0.03,
                        ),
                        itemCount: map[selectedGrade]!.length,
                        itemBuilder: (context, index) {
                          return ExerciseWidget(
                            exerciseName:
                                '${exerciseConfigs[map[selectedGrade]!.keys.elementAt(index).toString()]![0]}\n${exerciseConfigs[map[selectedGrade]!.keys.elementAt(index).toString()]![1]}',
                            onTap: () {
                              saveAndNavigate(
                                map[selectedGrade]!.keys.elementAt(index),
                                map[selectedGrade]!.values.elementAt(index),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                  if (state is StudentWise) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select a Student',
                          style: GoogleFonts.roboto(
                            fontSize: utils.subtitleSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showMyAddStudentAlartDialog(context);
                            // changed
                            // _manualBloc.add(AddStudentEvent());
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
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void saveAndNavigate(String exerciseName, int type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('exercise', exerciseName);
    await prefs.setInt('ansType', type);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ManualStudentsList(),
      ),
    );
  }

  Future<void> _showMyAddStudentAlartDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // User can tap outside to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Alert',
          ),
          content: Text(
            'Internet connection is required to add a student. Please ensure you are connected to proceed.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
                // want to space between the
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    _manualBloc.add(AddStudentEvent());
                  },
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
