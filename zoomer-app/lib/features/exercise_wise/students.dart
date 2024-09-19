import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/evaluation_type/add_student.dart';
import 'package:msap/features/exercise_wise/bloc/exercise_bloc.dart';
import 'package:msap/features/exercise_wise/student_details.dart' as e;
import 'package:msap/features/manual_assessment/student_details.dart' as m;
import 'package:msap/utils.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late ExerciseBloc _exerciseBloc;
  String exerciseName = '';
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
          child: BlocListener<ExerciseBloc, ExerciseState>(
            bloc: _exerciseBloc,
            listener: (context, state) {
              if (state is AddStudent) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddStudentForm()));
              } else if (state is AIAssessment) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const e.StudentDetailsScreen(),
                  ),
                );
              } else if (state is ManualAssessment) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const m.StudentDetailsScreen(),
                  ),
                );
              } else if (state is Auth) {
                setState(() {
                  exerciseName = state.exerciseName;
                  grade = state.grade;
                });
              }
            },
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
                        _exerciseBloc.add(AddStudentEvent());
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
                          _exerciseBloc.add(
                            StudentTapEvent(
                              studentName: names[index],
                            ),
                          );
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
                          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.05),
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
            ),
          ),
        ),
      ),
    );
  }
}
