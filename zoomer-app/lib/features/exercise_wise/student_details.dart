import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/exercise_wise/assessment.dart';
import 'package:msap/features/exercise_wise/band_calibration.dart';
import 'package:msap/features/exercise_wise/bloc/exercise_bloc.dart';
import 'package:msap/utils.dart';
import 'package:msap/widgets/band_callibration_widget.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late ExerciseBloc _exerciseBloc;
  String grade = '';
  String exerciseName = '';
  String studentName = '';

  final List<List<String>> bandCallibration = const [
    [
      'Arm Band',
      'Place the band on the student\'s arm at the\ncorrect position and secure it properly.'
    ],
    [
      'Resistance Band',
      'Adjust the resistance of the band as per the\nstudent\'s strength level.'
    ]
  ];

  @override
  void initState() {
    super.initState();
    _exerciseBloc = ExerciseBloc();
    _exerciseBloc.add(AuthEvent());
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
          child: BlocConsumer<ExerciseBloc, ExerciseState>(
            bloc: _exerciseBloc,
            listener: (context, state) {
              if (state is Auth) {
                setState(() {
                  grade = state.grade;
                  exerciseName = state.exerciseName;
                  studentName = state.studentName!;
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
                    'Type: $exerciseName',
                    style: GoogleFonts.roboto(
                      fontSize: utils.subtitleSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E3D75),
                    ),
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _exerciseBloc.add(AbsentEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state is Absent
                                ? utils.selectedContainer
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: state is Absent
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
                              color:
                                  state is Absent ? Colors.white : Colors.black,
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
                            _exerciseBloc.add(PresentEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state is Present
                                ? utils.selectedContainer
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: state is Present
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
                              color: state is Present
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: utils.subtitleSize * 0.7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  Text(
                    'Band Calibration',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFF1E3D75),
                      fontWeight: FontWeight.w500,
                      fontSize: utils.subtitleSize,
                    ),
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  Expanded(
                    child: ListView.separated(
                      itemCount: bandCallibration.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BandCalibration(),
                              ),
                            );
                          },
                          child: BandCallibrationWidget(
                            index: index,
                            bandName: bandCallibration[index][0],
                            description: bandCallibration[index][1],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(thickness: utils.screenWidth * 0.001);
                      },
                    ),
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  Center(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ExerciseWiseAssessment(),
                            ),
                          );
                        },
                        style: utils.elevatedButtonStyle(),
                        child: Text(
                          'Start',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: utils.subtitleSize,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
