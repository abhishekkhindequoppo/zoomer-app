import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:msap/features/manual_assessment/bloc/manual_bloc.dart';
import 'package:msap/features/manual_assessment/students.dart';
import 'package:msap/features/profile/profile.dart';
import 'package:msap/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/golain_api_services.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late Map<String, int> questions = {};
  int index = 0;
  late ManualBloc _manualBloc;
  final TextEditingController _controller = TextEditingController();
  String grade = '';
  String studentName = '';
  String division = '';
  final map = Utils.gradeQuestionType;
  String schoolName = '';
  List<Map<String, dynamic>> evaluatedStudentDatas = [];
  Map<String, dynamic> answers = {};

  static final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    _manualBloc = ManualBloc();
    _manualBloc.add(AuthEvent());
    _manualBloc.add(ShowPopupEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    _manualBloc.close();
    super.dispose();
  }

  Future<void> checkAndMoveToNextQuestion() async {
    bool shouldSkip;
    do {
      shouldSkip =
          await checkForRepeatQuestion(questions.keys.elementAt(index));
      if (shouldSkip) {
        index++;
        if (index >= questions.length) {
          // All questions have been checked, end the evaluation
          await submitEvaluation();
          _manualBloc.add(EndQuestionsEvent());
          return;
        }
      }
    } while (shouldSkip);

    // Update UI for the current question
    setState(() {
      String currentQuestion = questions.keys.elementAt(index);
      _controller.text = answers[currentQuestion] ?? '';
    });
  }

  Future<void> moveToNextQuestion() async {
    index++;
    if (index >= questions.length) {
      // All questions have been checked, end the evaluation
      await submitEvaluation();
      _manualBloc.add(EndQuestionsEvent());
      return;
    }

    await checkAndMoveToNextQuestion();
  }

  Future<bool> checkForRepeatQuestion(String question) async {
    final prefs = await SharedPreferences.getInstance();
    final schoolName = prefs.getString('school_name') ?? '';
    final grade = prefs.getString('selectedGrade') ?? '';
    final division = prefs.getString('selectedDivision') ?? '';
    final studentName = prefs.getString('student') ?? '';

    final golainApiService = getIt<GolainApiService>();
    evaluatedStudentDatas = await golainApiService.getChecklistStudents(
        schoolName, grade, division, 1);

    if (evaluatedStudentDatas.isNotEmpty) {
      for (var studentData in evaluatedStudentDatas) {
        if (studentData['student_name'] == studentName) {
          if (studentData['attendance'] == 'Present') {
            String apiField = questionToApiFieldMap[question] ?? '';
            if (studentData[apiField] != 0 && studentData[apiField] != '') {
              log('Skipping question $question for student $studentName');
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  Future<void> submitEvaluation() async {
    final prefs = await SharedPreferences.getInstance();
    final schoolName = prefs.getString('school_name') ?? '';
    final grade = prefs.getString('selectedGrade') ?? '';
    final division = prefs.getString('selectedDivision') ?? '';
    final studentName = prefs.getString('student') ?? '';
    final attendance = prefs.getString('attendance') ?? '';
    final timestamp = DateTime.now().toIso8601String() + '+05:30';

    final Map<String, dynamic> evaluationData = {
      "school_name": schoolName,
      "grade": grade,
      "division": division,
      "student_name": studentName,
      "roll_no": 0,
      "attendance": attendance,
      "evaluation_number": 1,
      "time_of_eval": timestamp,
      "year_of_eval": timestamp,
      "instructor_name": "",
      "image_id": "",
      "skipping": 0,
      "hit_balloon_up": 0,
      "dribbling_ball_8": 0,
      "dribbling_ball_O": 0,
      "jump_symmetrically": 0,
      "hop_9m_dominant_leg": 0,
      "jump_asymmetrically": 0,
      "ball_bounce_and_catch": 0,
      "criss_cross_with_clap": 0,
      "stand_on_dominant_leg": 0,
      "hop_9m_nondominant_leg": 0,
      "step_down_dominant_leg": "",
      "step_over_dominant_leg": "",
      "criss_cross_leg_forward": 0,
      "jumping_jacks_with_clap": 0,
      "criss_cross_without_clap": 0,
      "hop_forward_dominant_leg": 0,
      "stand_on_nondominant_leg": 0,
      "step_down_nondominant_leg": "",
      "step_over_nondominant_leg": "",
      "jumping_jacks_without_clap": 0,
      "hop_forward_nondominant_leg": 0,
      "forward_backward_spread_legs": 0,
      "alternate_forward_backward_legs": 0
    };

    // Map answers to API fields
    for (var entry in answers.entries) {
      final question = entry.key;
      final answer = entry.value;
      final apiField = questionToApiFieldMap[question];
      if (apiField != null) {
        if (questions[question] == 0) {
          // Yes/No question
          evaluationData[apiField] = answer;
        } else {
          // Numeric question
          evaluationData[apiField] = int.tryParse(answer) ?? 0;
        }
      }
    }

    // Call the API
    final apiService = getIt<GolainApiService>();
    final result = await apiService.postStudentEvaluation(evaluationData);
    if (result) {
      Utils.showSuccess('Evaluation submitted successfully');
    } else {
      Utils.showError('Failed to submit evaluation');
    }
  }

// offline code to store evaluation data in Hive
  Future<void> storeEvaluationInHive() async {
    final prefs = await SharedPreferences.getInstance();
    final schoolName = prefs.getString('school_name') ?? '';
    final grade = prefs.getString('selectedGrade') ?? '';
    final division = prefs.getString('selectedDivision') ?? '';
    final studentName = prefs.getString('student') ?? '';
    final attendance = prefs.getString('attendance') ?? '';
    final timestamp = DateTime.now().toIso8601String() + '+05:30';
    final imageUrl = prefs.getString('image_id') ?? '';

    // Create the evaluation data map
    final Map<String, dynamic> evaluationData = {
      "school_name": schoolName,
      "grade": grade,
      "division": division,
      "student_name": studentName,
      "roll_no": 0,
      "attendance": attendance,
      "evaluation_number": 1,
      "time_of_eval": timestamp,
      "year_of_eval": timestamp,
      "instructor_name": "",
      "image_id": imageUrl,
      "skipping": 0,
      "hit_balloon_up": 0,
      "dribbling_ball_8": 0,
      "dribbling_ball_O": 0,
      "jump_symmetrically": 0,
      "hop_9m_dominant_leg": 0,
      "jump_asymmetrically": 0,
      "ball_bounce_and_catch": 0,
      "criss_cross_with_clap": 0,
      "stand_on_dominant_leg": 0,
      "hop_9m_nondominant_leg": 0,
      "step_down_dominant_leg": "",
      "step_over_dominant_leg": "",
      "criss_cross_leg_forward": 0,
      "jumping_jacks_with_clap": 0,
      "criss_cross_without_clap": 0,
      "hop_forward_dominant_leg": 0,
      "stand_on_nondominant_leg": 0,
      "step_down_nondominant_leg": "",
      "step_over_nondominant_leg": "",
      "jumping_jacks_without_clap": 0,
      "hop_forward_nondominant_leg": 0,
      "forward_backward_spread_legs": 0,
      "alternate_forward_backward_legs": 0
    };

    // Map the answers to the respective Hive fields
    for (var entry in answers.entries) {
      final question = entry.key;
      final answer = entry.value;
      final hiveField = questionToApiFieldMap[question];

      if (hiveField != null) {
        if (questions[question] == 0) {
          // Yes/No question
          evaluationData[hiveField] = answer;
        } else {
          // Numeric question
          evaluationData[hiveField] = int.tryParse(answer) ?? 0;
        }
      }
    }

    // Store the data in Hive
    var box = await Hive.openBox('evaluationData');
    await box.put('evaluationRecord', evaluationData);

    print("get from hive: ${box.get('evaluationRecord')}");
    log("Evaluation data stored in Hive");

    Utils.showSuccess('Evaluation submitted successfully to Hive');
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
              if (state is NextQuestion) {
                moveToNextQuestion();
              } else if (state is PreviousQuestion) {
                setState(() {
                  if (index > 0) {
                    index--;
                    _controller.text =
                        answers[questions.keys.elementAt(index)] ?? '';
                  }
                });
              } else if (state is AllQuestionsCompletedState) {
                submitEvaluation().then((_) {
                  _manualBloc.add(EndQuestionsEvent());
                });
              } else if (state is Auth) {
                setState(() {
                  grade = state.grade;
                  division = state.division;
                  studentName = state.studentName!;
                  questions = Map.from(Utils.gradeQuestionType[grade] ?? {});
                  answers = Map.fromEntries(
                      questions.keys.map((q) => MapEntry(q, '')));
                });
                // Check the first question after authentication
                checkAndMoveToNextQuestion();
              } else if (state is EndQuestions) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManualStudentsList()),
                  (route) => false,
                );
              } else if (state is ShowPopupState) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Click Picture'),
                    content: const Text(
                        'Click a picture of the student assessment.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Trigger image picking event
                          _manualBloc.add(PickImageEvent());
                          Navigator.of(context).pop();
                        },
                        child: const Text('Click'),
                      ),
                    ],
                  ),
                );
              } else if (state is ImagePickedState) {
                // Show success message with the image URL
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Image uploaded: ${state.imageUrl}'),
                ));
              } else if (state is ImageUploadFailedState) {
                // Show Failed message

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Image upload failed.'),
                ));
              }
            },
            builder: (context, state) {
              if (state is EndQuestions) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (questions.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: utils.titleSize,
                              ),
                            ),
                            SizedBox(width: utils.screenWidth * 0.02),
                            Text(
                              grade,
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: utils.paddingHorizontal,
                        vertical: utils.paddingVertical,
                      ),
                      decoration: utils.detailsContainerDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Name',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFA09CAB),
                              fontWeight: FontWeight.w600,
                              fontSize: utils.subtitleSize * 0.8,
                            ),
                          ),
                          SizedBox(height: utils.screenHeight * 0.01),
                          Text(
                            studentName,
                            style: GoogleFonts.inter(
                              fontSize: utils.subtitleSize * 0.7,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: utils.screenHeight * 0.03),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Grade',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFA09CAB),
                                      fontWeight: FontWeight.w600,
                                      fontSize: utils.subtitleSize * 0.8,
                                    ),
                                  ),
                                  SizedBox(height: utils.screenHeight * 0.01),
                                  Text(
                                    grade,
                                    style: GoogleFonts.inter(
                                      fontSize: utils.subtitleSize * 0.7,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: utils.screenWidth * 0.2),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Division',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFA09CAB),
                                      fontWeight: FontWeight.w600,
                                      fontSize: utils.subtitleSize * 0.8,
                                    ),
                                  ),
                                  SizedBox(height: utils.screenHeight * 0.01),
                                  Text(
                                    division,
                                    style: GoogleFonts.inter(
                                      fontSize: utils.subtitleSize * 0.7,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: utils.screenHeight * 0.03),
                    Text(
                      questions.keys.elementAt(index),
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: utils.subtitleSize,
                      ),
                    ),
                    SizedBox(height: utils.screenHeight * 0.03),
                    questions[questions.keys.elementAt(index)] == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      answers[questions.keys.elementAt(index)] =
                                          'No';
                                    });
                                  },
                                  style: answers[questions.keys
                                              .elementAt(index)] ==
                                          'No'
                                      ? utils.elevatedButtonStyle().copyWith(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  utils.selectedContainer))
                                      : utils.elevatedButtonStyle(),
                                  child: Text(
                                    'No',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF1E3D75),
                                      fontSize: utils.subtitleSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: utils.screenWidth * 0.02),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      answers[questions.keys.elementAt(index)] =
                                          'Yes';
                                    });
                                  },
                                  style: answers[questions.keys
                                              .elementAt(index)] ==
                                          'Yes'
                                      ? utils.elevatedButtonStyle().copyWith(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  utils.selectedContainer))
                                      : utils.elevatedButtonStyle(),
                                  child: Text(
                                    'Yes',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF1E3D75),
                                      fontSize: utils.subtitleSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : TextField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter number',
                              hintStyle: GoogleFonts.roboto(
                                color: const Color.fromRGBO(0, 0, 0, 0.5),
                                fontSize: utils.subtitleSize,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(utils.borderRadius),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                answers[questions.keys.elementAt(index)] =
                                    value;
                              });
                            },
                          ),
                    SizedBox(height: utils.screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (index != 0)
                          ElevatedButton(
                            style: utils.elevatedButtonStyle().copyWith(
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color(0xFF1E3D75))),
                            onPressed: () {
                              _manualBloc.add(PreviousQuestionEvent());
                            },
                            child: Text(
                              'Back',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: utils.subtitleSize,
                              ),
                            ),
                          ),
                        if (index == 0) const Spacer(),
                        ElevatedButton(
                          style: utils.elevatedButtonStyle().copyWith(
                                backgroundColor: WidgetStateProperty.all(
                                  const Color(0xFF1E3D75),
                                ),
                              ),
                          onPressed: () async {
                            // Check internet connectivity
                            var connectivityResult =
                                await Connectivity().checkConnectivity();

                            // Assuming you want to handle actual internet connection, not just network status
                            bool isConnected = false;
                            if (connectivityResult != ConnectivityResult.none) {
                              try {
                                // Perform a small network request to check actual internet access
                                final result =
                                    await InternetAddress.lookup('example.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  isConnected = true;
                                }
                              } catch (_) {
                                isConnected = false;
                              }
                            }

                            if (isConnected) {
                              // Internet is available, submit to API
                              if (index == 5) {
                                await submitEvaluation().then((_) {
                                  _manualBloc.add(EndQuestionsEvent());
                                });
                                log("post API request if connected");
                              } else {
                                _manualBloc.add(
                                    NextQuestionEvent(currentIndex: index));
                              }
                            } else {
                              // Internet is not available, store data in Hive
                              if (index == 5) {
                                await storeEvaluationInHive();
                                _manualBloc.add(EndQuestionsEvent());
                                log("store data in hive if not connected");
                              } else {
                                _manualBloc.add(
                                    NextQuestionEvent(currentIndex: index));
                              }
                            }
                          },
                          child: Text(
                            index != 5 ? 'Next' : 'End',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: utils.subtitleSize,
                            ),
                          ),
                        )

                        // ElevatedButton(
                        //   style: utils.elevatedButtonStyle().copyWith(
                        //       backgroundColor: const WidgetStatePropertyAll(
                        //           Color(0xFF1E3D75))),
                        //   onPressed: () {
                        //     if (index < questions.length - 1) {
                        //       _manualBloc
                        //           .add(NextQuestionEvent(currentIndex: index));
                        //     } else {
                        //       _manualBloc.add(AllQuestionsCompletedEvent());
                        //     }
                        //   },
                        //   child: Text(
                        //     index != questions.length - 1 ? 'Next' : 'End',
                        //     style: GoogleFonts.roboto(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: utils.subtitleSize,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
