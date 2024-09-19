import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/manual_assessment/bloc/manual_bloc.dart';
import 'package:msap/features/manual_assessment/students.dart';
import 'package:msap/features/profile/profile.dart';
import 'package:msap/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import '../../services/golain_api_services.dart';
import 'dart:developer';

class ManualExerciseWise extends StatefulWidget {
  const ManualExerciseWise({super.key});

  @override
  State<ManualExerciseWise> createState() => _ManualExerciseWiseState();
}

class _ManualExerciseWiseState extends State<ManualExerciseWise> {
  String grade = '';
  String studentName = '';
  String exercise = '';
  int type = 0;
  late ManualBloc _manualBloc;
  dynamic answer = '';
  final TextEditingController _controller = TextEditingController();

  Future<void> submitEvaluation() async {
  final prefs = await SharedPreferences.getInstance();
  final schoolName = prefs.getString('school_name') ?? '';
  final grade = prefs.getString('selectedGrade') ?? '';
  final division = prefs.getString('selectedDivision') ?? '';
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

  log(exercise);

  // Map the current exercise to the corresponding API field
  final apiField = questionToApiFieldMap[exercise];
  if (apiField != null) {
    if (type == 0) { // Yes/No question
      evaluationData[apiField] = answer;
    } else { // Numeric question
      evaluationData[apiField] = answer as int;
    }
  }

  // Call the API
  final getIt = GetIt.instance;
  final apiService = getIt<GolainApiService>();
  final result = await apiService.postStudentEvaluation(evaluationData);
  if (result) {
    Utils.showSuccess('Evaluation submitted successfully');
  } else {
    Utils.showError('Failed to submit evaluation');
  }
}

  void loadExercise() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? exerciseName = prefs.getString('exercise');
    int? i = prefs.getInt('ansType');

    setState(() {
      exercise = exerciseName!;
      type = i!;
    });
  }

  @override
  void initState() {
    super.initState();
    _manualBloc = ManualBloc();
    _manualBloc.add(AuthEvent());
    loadExercise();
  }

  @override
  void dispose() {
    _manualBloc.close();
    super.dispose();
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
          child: BlocListener<ManualBloc, ManualState>(
            bloc: _manualBloc,
            listener: (context, state) {
              if (state is Auth) {
                setState(() {
                  grade = state.grade;
                  studentName = state.studentName!;
                });
              }
            },
            child: SingleChildScrollView(
              child: Column(
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
                                  'Roll No',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFA09CAB),
                                    fontWeight: FontWeight.w600,
                                    fontSize: utils.subtitleSize * 0.8,
                                  ),
                                ),
                                SizedBox(height: utils.screenHeight * 0.01),
                                Text(
                                  '12345',
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
                                  'Age',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFA09CAB),
                                    fontWeight: FontWeight.w600,
                                    fontSize: utils.subtitleSize * 0.8,
                                  ),
                                ),
                                SizedBox(height: utils.screenHeight * 0.01),
                                Text(
                                  '10',
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
                    exercise,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: utils.subtitleSize,
                    ),
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  type == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    answer = 'No';
                                  });
                                },
                                style: answer == 'No'
                                    ? utils.elevatedButtonStyle().copyWith(
                                        backgroundColor: WidgetStatePropertyAll(
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
                                    answer = 'Yes';
                                  });
                                },
                                style: answer == 'Yes'
                                    ? utils.elevatedButtonStyle().copyWith(
                                        backgroundColor: WidgetStatePropertyAll(
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
                              answer = int.parse(value);
                            });
                          },
                        ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  ElevatedButton(
                    onPressed: () async {
                      await submitEvaluation();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManualStudentsList(exerciseName: exercise),
                        ),
                      );
                    },
                    style: utils.elevatedButtonStyle().copyWith(
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0xFF1E3D75))),
                    child: Text(
                      'Yes',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: utils.subtitleSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
