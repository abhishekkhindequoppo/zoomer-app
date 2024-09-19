import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:msap/features/evaluation_type/add_student.dart';
import 'package:msap/features/evaluation_type/bloc/evaluation_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msap/features/exercise_wise/devices.dart';
import 'package:msap/features/exercise_wise/students.dart';
import 'package:msap/features/manual_assessment/student_details.dart';
import 'package:msap/utils.dart';
import 'package:msap/widgets/exercise_widget.dart';

class EvaluationTypeScreen extends StatefulWidget {
  const EvaluationTypeScreen({super.key});

  @override
  State<EvaluationTypeScreen> createState() => _EvaluationTypeScreenState();
}

class _EvaluationTypeScreenState extends State<EvaluationTypeScreen> {
  late EvaluationBloc _evaluationBloc;
  String grade = '';

  final List<String> names = [
    'Advait',
    'Manthan',
    'Namay',
    'Kshitij',
    'Pranay',
    'Vaibhav',
    'Raghav',
    'Saloni',
    'Sanika',
    'Saurav',
  ];

  @override
  void initState() {
    super.initState();
    _evaluationBloc = EvaluationBloc();
    _evaluationBloc.add(EvaluationAuthEvent());
  }

  @override
  void dispose() {
    _evaluationBloc.close();
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
          child: BlocConsumer<EvaluationBloc, EvaluationState>(
            bloc: _evaluationBloc,
            listener: (context, state) {
              if (state is AddStudent) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddStudentForm(),
                  ),
                );
              } else if (state is EvaluationAuth) {
                setState(() {
                  grade = state.grade;
                });
              } else if (state is AIAssessment) {
              } else if (state is ManualAssessment) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentDetailsScreen(),
                  ),
                );
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
                        onPressed: () {},
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
                          _evaluationBloc.add(ExerciseWiseEvent());
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
                          _evaluationBloc.add(StudentWiseEvent());
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
                  if (state is StudentWise) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select a Student',
                          style: GoogleFonts.roboto(
                            fontSize: utils.subtitleSize * 0.8,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _evaluationBloc.add(AddStudentEvent());
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
                        itemCount: names.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              _evaluationBloc.add(
                                  StudentTapEvent(studentName: names[index]));
                            },
                            title: Text(
                              names[index],
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: utils.subtitleSize,
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: utils.avatarRadius,
                              backgroundColor:
                                  const Color.fromRGBO(0, 0, 0, 0.05),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: utils.avatarRadius,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(thickness: utils.screenHeight * 0.001);
                        },
                      ),
                    )
                  ],
                  if (state is ExerciseWise) ...[
                    Text(
                      'Exercises',
                      style: GoogleFonts.roboto(
                        fontSize: utils.subtitleSize * 0.7,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: utils.screenHeight * 0.03),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: utils.screenWidth * 0.03,
                        mainAxisSpacing: utils.screenHeight * 0.03,
                        children: [
                          ExerciseWidget(
                            exerciseName: 'Leg Balance',
                            onTap: () {
                              saveAndNavigate('Leg Balance');
                            },
                          ),
                          ExerciseWidget(
                            exerciseName: 'Skipping Rope',
                            onTap: () {
                              saveAndNavigate('Skipping Rope');
                            },
                          ),
                          ExerciseWidget(
                            exerciseName: 'One Leg Hop',
                            onTap: () {
                              saveAndNavigate('One Leg Hop');
                            },
                          ),
                          ExerciseWidget(
                            exerciseName: 'Skipping Rope',
                            onTap: () {
                              saveAndNavigate('Skipping Rope');
                            },
                          ),
                        ],
                      ),
                    )
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void saveAndNavigate(String exerciseName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('exercise', exerciseName);

    String? res = prefs.getString('assessment');
    if (res == 'AI') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DevicesScreen()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const StudentsScreen()));
    }
  }
}
