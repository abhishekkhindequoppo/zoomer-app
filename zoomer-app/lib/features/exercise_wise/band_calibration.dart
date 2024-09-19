import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/exercise_wise/assessment.dart';
import 'package:msap/features/exercise_wise/bloc/exercise_bloc.dart';
import 'package:msap/utils.dart';

class BandCalibration extends StatefulWidget {
  const BandCalibration({super.key});

  @override
  State<BandCalibration> createState() => _BandCalibrationState();
}

class _BandCalibrationState extends State<BandCalibration>
    with SingleTickerProviderStateMixin {
  bool isComplete = false;
  late ExerciseBloc _exerciseBloc;
  String grade = '';
  String exerciseName = '';
  String studentName = '';

  @override
  void initState() {
    super.initState();
    _exerciseBloc = ExerciseBloc();
    _exerciseBloc.add(AuthEvent());
  }

  @override
  void dispose() {
    _exerciseBloc.close();
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
          child: Center(
            child: BlocConsumer<ExerciseBloc, ExerciseState>(
              bloc: _exerciseBloc,
              listener: (context, state) {
                if (state is NavigateToAssessmentScreen) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExerciseWiseAssessment(),
                    ),
                  );
                } else if (state is Auth) {
                  setState(() {
                    grade = state.grade;
                    exerciseName = state.exerciseName;
                    studentName = state.studentName!;
                  });
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(children: [
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
                    if (isComplete == false) ...[
                      const Image(
                        image: AssetImage('assets/images/band.png'),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: utils.screenHeight * 0.02),
                      Text(
                        'Band Calibration\nin progress!',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: utils.subtitleSize,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: utils.screenHeight * 0.02),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('STOP'),
                      )
                    ] else ...[
                      const Image(
                        image: AssetImage('assets/images/check.png'),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: utils.screenHeight * 0.02),
                      Text(
                        'Band Calibration\ncomplete',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: utils.subtitleSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
