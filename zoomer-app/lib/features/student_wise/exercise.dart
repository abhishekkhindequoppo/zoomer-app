import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/student_wise/bloc/student_bloc.dart';
import 'package:msap/utils.dart';

class ExerciseSelectScreen extends StatefulWidget {
  const ExerciseSelectScreen({super.key});

  @override
  State<ExerciseSelectScreen> createState() => _ExerciseSelectScreenState();
}

class _ExerciseSelectScreenState extends State<ExerciseSelectScreen> {
  String grade = '';
  String studentName = '';
  late StudentBloc _studentBloc;

  @override
  void initState() {
    super.initState();
    _studentBloc = StudentBloc();
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: utils.paddingHorizontal,
          vertical: utils.paddingVertical,
        ),
        child: BlocConsumer<StudentBloc, StudentState>(
          bloc: _studentBloc,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Column(
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
                          _studentBloc.add(AbsentEvent());
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
                          _studentBloc.add(PresentEvent());
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
                            color:
                                state is Present ? Colors.white : Colors.black,
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
                  'Select exercise',
                  style: GoogleFonts.roboto(
                    color: utils.selectedContainer,
                    fontSize: utils.subtitleSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.03),
              ],
            );
          },
        ),
      ),
    );
  }
}
