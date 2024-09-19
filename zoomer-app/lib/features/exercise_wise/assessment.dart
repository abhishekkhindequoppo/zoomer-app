import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/exercise_wise/bloc/exercise_bloc.dart';
import 'package:msap/features/home/grades.dart';
import 'package:msap/utils.dart';

class ExerciseWiseAssessment extends StatefulWidget {
  const ExerciseWiseAssessment({super.key});

  @override
  State<ExerciseWiseAssessment> createState() => _ExerciseWiseAssessmentState();
}

class _ExerciseWiseAssessmentState extends State<ExerciseWiseAssessment> {
  late ExerciseBloc _exerciseBloc;
  Timer? elapsedTimer;
  int elapsedTime = 0;
  String grade = '';
  String exerciseName = '';
  String studentName = '';

  @override
  void initState() {
    super.initState();
    _exerciseBloc = ExerciseBloc();
    _exerciseBloc.add(AuthEvent());
    _exerciseBloc.add(StudentDetailsEvent());
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
              if (state is StartAssessment) {
                setState(() {
                  elapsedTime = 0;
                });
                elapsedTimer =
                    Timer.periodic(const Duration(seconds: 1), (timer) {
                  setState(() {
                    elapsedTime++;
                  });
                });
              } else if (state is StopAssessment) {
                elapsedTimer?.cancel();
              } else if (state is PauseAssessment) {
                elapsedTimer?.cancel();
              } else if (state is ResumeAssessment) {
                elapsedTimer =
                    Timer.periodic(const Duration(seconds: 1), (timer) {
                  setState(() {
                    elapsedTime++;
                  });
                });
              } else if (state is Auth) {
                setState(() {
                  exerciseName = state.exerciseName;
                  grade = state.grade;
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
                      Text(
                        'Assessment',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: utils.titleSize,
                        ),
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
                  if (state is StudentDetails || state is Auth) ...[
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _exerciseBloc.add(StartAssessmentEvent());
                            },
                            style: utils.elevatedButtonStyle(),
                            child: Text(
                              'Start Assessment',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: utils.subtitleSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                  if (state is StartAssessment ||
                      state is PauseAssessment ||
                      state is ResumeAssessment)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: utils.paddingHorizontal,
                            vertical: utils.paddingVertical,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.circular(utils.borderRadius),
                          ),
                          child: Text(
                            'Elapsed Time: $elapsedTime seconds',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: utils.subtitleSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: utils.screenHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _exerciseBloc.add(StopAssessmentEvent());
                                },
                                style: utils.elevatedButtonStyle(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.stop_circle_outlined,
                                      size: utils.subtitleSize,
                                    ),
                                    Text(
                                      'Stop',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: utils.subtitleSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: utils.screenWidth * 0.05),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  state is PauseAssessment
                                      ? _exerciseBloc
                                          .add(ResumeAssessmentEvent())
                                      : _exerciseBloc
                                          .add(PauseAssessmentEvent());
                                },
                                style: utils.elevatedButtonStyle(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      state is PauseAssessment
                                          ? Icons.play_arrow_outlined
                                          : Icons.pause_outlined,
                                      size: utils.subtitleSize,
                                    ),
                                    Text(
                                      state is PauseAssessment
                                          ? 'Resume'
                                          : 'Pause',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: utils.subtitleSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  if (state is StopAssessment) ...[
                    Center(
                      child: Text(
                        'Assessment\nComplete!',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: utils.titleSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: utils.screenHeight * 0.05),
                    Center(
                      child: Image(
                        image: const AssetImage('assets/images/check.png'),
                        height: utils.screenHeight * 0.2,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(
                      height: utils.screenHeight * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            },
                            style: utils.elevatedButtonStyle(),
                            child: Text(
                              'Save\nReport',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: utils.subtitleSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: utils.screenWidth * 0.05),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _exerciseBloc.add(StartAssessmentEvent());
                            },
                            style: utils.elevatedButtonStyle(),
                            child: Text(
                              'Redo\nAssessment',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: utils.subtitleSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
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
}
