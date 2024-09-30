import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/manual_assessment/bloc/manual_bloc.dart';
import 'package:msap/features/manual_assessment/exercise_wise.dart';
import 'package:msap/features/manual_assessment/questions_screen.dart';
import 'package:msap/features/manual_assessment/students.dart';
import 'package:msap/features/profile/profile.dart';
import 'package:msap/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/golain_api_services.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer';

class StudentDetailsScreen extends StatefulWidget {
  final String exerciseName;

  const StudentDetailsScreen({
    super.key,
    this.exerciseName = ''
  });

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late ManualBloc _manualBloc;
  String grade = '';
  String studentName = '';
  String division = '';
  String attendance = '';
  static final getIt = GetIt.instance;
  String exerciseName = '';

  @override
  void initState() {
    super.initState();
    _getGradeAndDivision();
    _manualBloc = ManualBloc();
    _manualBloc.add(AuthEvent());
  }

  Future<void> _getGradeAndDivision() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      grade = prefs.getString('selectedGrade') ?? 'Nursery';
      division = prefs.getString('selectedDivision') ?? 'A';
      exerciseName = prefs.getString('exercise') ?? '';
    });
  }

  Future<void> submitAbsentEvaluation() async {
    final prefs = await SharedPreferences.getInstance();
    final schoolName = prefs.getString('school_name') ?? '';
    final grade = prefs.getString('selectedGrade') ?? '';
    final division = prefs.getString('selectedDivision') ?? '';
    final studentName = prefs.getString('student') ?? '';
    final timestamp = DateTime.now().toIso8601String() + '+05:30';

    final Map<String, dynamic> evaluationData = {
      "school_name": schoolName,
      "grade": grade,
      "division": division,
      "student_name": studentName,
      "roll_no": 0,
      "attendance": "Absent",
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

    // Call the API
    final apiService = getIt<GolainApiService>();
    final result = await apiService.postStudentEvaluation(evaluationData);
    if (result) {
      Utils.showSuccess('Absent evaluation submitted successfully');
    } else {
      Utils.showError('Failed to submit absent evaluation');
    }
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
              if (state is Questions && exerciseName.isEmpty) {
                log(widget.exerciseName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionsScreen(),
                  ),
                );
              } 
              else if (state is Questions && exerciseName.isNotEmpty) {
                log(widget.exerciseName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManualExerciseWise(),
                  ),
                );
              }
              else if (state is Auth) {
                setState(() {
                  grade = state.grade;
                  studentName = state.studentName ?? '';
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              attendance = "Absent";
                            });
                            _manualBloc.add(AbsentEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: attendance == "Absent"
                                ? utils.selectedContainer
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: attendance == "Absent"
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
                            'Absent',
                            style: GoogleFonts.roboto(
                              color: attendance == "Absent" ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: utils.subtitleSize * 0.7,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: utils.screenWidth * 0.04),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              attendance = "Present";
                            });
                            _manualBloc.add(PresentEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: attendance == "Present"
                                ? utils.selectedContainer
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: attendance == "Present"
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
                            'Mark Present',
                            style: GoogleFonts.roboto(
                              color: attendance == "Present" ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: utils.subtitleSize * 0.7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  Center(
                    child: ElevatedButton(
                      style: utils.elevatedButtonStyle(),
                      onPressed: () async {
                        if (attendance == "Absent") {
                          await submitAbsentEvaluation();
                          Navigator.pop(context); // Go back to student list
                        } else if (attendance == "Present") {
                          // Save attendance to SharedPreferences
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('attendance', attendance);
                          
                          // Trigger the QuestionsEvent
                          _manualBloc.add(QuestionsEvent(attendance: attendance));
                        } else {
                          // If no attendance is selected, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select attendance status')),
                          );
                        }
                      },
                      child: Text(
                        attendance == "Absent" ? 'Submit' : 'Start',
                        style: GoogleFonts.inter(
                          fontSize: utils.subtitleSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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