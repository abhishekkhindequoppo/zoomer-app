import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:msap/features/manual_assessment/manual_evaluation_type.dart';
import 'package:msap/features/manual_assessment/students.dart';
import 'package:msap/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:msap/services/golain_api_services.dart';
import 'package:msap/models/student.dart';
import 'package:get_it/get_it.dart';

class AddStudentForm extends StatefulWidget {
  const AddStudentForm({super.key});

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();

  static final getIt = GetIt.instance;
  final golainApiService = getIt<GolainApiService>();

  void validateAndSubmit() async {
    // Validate if student name is empty
    if (_nameController.text.isEmpty) {
      Utils.showShorterToast('Student Name is required');
      return;
    }

    // Parse roll number or default to 0 if the field is empty
    int rollNo = _rollNoController.text.isEmpty
        ? 0
        : int.tryParse(_rollNoController.text) ?? 0;

    // Retrieve school details from shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schoolName = prefs.getString('school_name') ?? '';
    String? grade = prefs.getString('selectedGrade') ?? '';
    String? division = prefs.getString('selectedDivision') ?? '';

    // Create a Student object
    final student = Student(
      schoolName: schoolName,
      grade: grade,
      division: division,
      studentName: _nameController.text,
      rollNo: rollNo,
    );

    try {
      // Attempt to post student data to the API
      bool success = await golainApiService.postStudentData(student);

      if (success) {
        Utils.showShorterToast('Student added successfully');
        navigateToNextScreen(prefs);
      } else {
        throw Exception('API returned false for success');
      }
    } catch (e) {
      log("Error posting student data: $e");
      // If there's any error in posting data, treat it as an offline scenario
      await handleOfflineSubmission(student, grade, division, prefs);
    }
  }

  Future<void> handleOfflineSubmission(Student student, String grade,
      String division, SharedPreferences prefs) async {
    Utils.showShorterToast(
        'Unable to connect to server. Storing data locally.');
    log("offline_add_student_form");

    try {
      // Store student data in Hive for offline use
      final box = await Hive.openBox('studentData');
      final gradeDivisionKey = '$grade-$division';

      // Check if the grade and division box exists
      if (!box.containsKey(gradeDivisionKey)) {
        box.put(gradeDivisionKey, []);
      }
      log("Storing student data in Hive: $student");

      // Add student data to the respective list
      final List<Student> students =
          List<Student>.from(box.get(gradeDivisionKey) ?? []);
      students.add(student);
      await box.put(gradeDivisionKey, students);
      log("Successfully stored student data in Hive");

      Utils.showShorterToast(
          'Student data stored locally. Will sync when online.');

      navigateToNextScreen(prefs);
    } catch (e) {
      log("Error storing data in Hive: $e");
      Utils.showShorterToast('Error storing data locally');
    }
  }

  void navigateToNextScreen(SharedPreferences prefs) {
    String? type = prefs.getString('type');

    if (type == 's') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ManualStudentsList(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ManualEvaluationType(),
        ),
      );
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: utils.iconSize,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Add Student',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: utils.titleSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: utils.screenHeight * 0.03),
                _buildTextField('Student Name', _nameController, utils),
                SizedBox(height: utils.screenHeight * 0.03),
                _buildTextField('Roll No (Optional)', _rollNoController, utils,
                    TextInputType.number),
                SizedBox(height: utils.screenHeight * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: validateAndSubmit,
                    style: utils.elevatedButtonStyle(),
                    child: Text(
                      'Save Details',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: utils.screenWidth * 0.045,
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

  Widget _buildTextField(
      String label, TextEditingController controller, Utils utils,
      [TextInputType? keyboardType]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E3D75),
            fontSize: utils.subtitleSize,
          ),
        ),
        SizedBox(height: utils.screenHeight * 0.01),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: utils.addStudentTextFieldDecoration('Enter $label'),
        ),
      ],
    );
  }
}
