import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/assessment_type/bloc/assessment_bloc.dart';
import 'package:msap/features/home/grades.dart';
import 'package:msap/utils.dart';

class AssessmentTypeScreen extends StatefulWidget {
  const AssessmentTypeScreen({super.key});

  @override
  State<AssessmentTypeScreen> createState() => _AssessmentTypeScreenState();
}

class _AssessmentTypeScreenState extends State<AssessmentTypeScreen> {
  late AssessmentBloc _assessmentBloc;

  @override
  void initState() {
    super.initState();
    _assessmentBloc = AssessmentBloc();
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
          child: BlocListener<AssessmentBloc, AssessmentState>(
            bloc: _assessmentBloc,
            listener: (context, state) {
              if (state is AIAssessment || state is ManualAssessment) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Assessment Type',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: utils.titleSize,
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _assessmentBloc.add(AIAssessmentEvent());
                    },
                    style: utils.elevatedButtonStyle().copyWith(
                          backgroundColor:
                              const WidgetStatePropertyAll(Color(0xFF1E3D75)),
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          side: WidgetStatePropertyAll(
                            BorderSide(
                              color: utils.selectedContainer,
                              width: 1.5,
                            ),
                          ),
                        ),
                    child: Text(
                      'AI Assessment',
                      style: GoogleFonts.roboto(
                        fontSize: utils.subtitleSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.03),
                Center(
                  child: Text(
                    'OR',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: utils.subtitleSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _assessmentBloc.add(ManualAssessmentEvent());
                    },
                    style: utils.elevatedButtonStyle().copyWith(
                          side: WidgetStatePropertyAll(
                            BorderSide(
                              color: utils.selectedContainer,
                              width: 1.5,
                            ),
                          ),
                          backgroundColor:
                              const WidgetStatePropertyAll(Color(0xFF1E3D75)),
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                        ),
                    child: Text(
                      'Manual Assessment',
                      style: GoogleFonts.roboto(
                        fontSize: utils.subtitleSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
