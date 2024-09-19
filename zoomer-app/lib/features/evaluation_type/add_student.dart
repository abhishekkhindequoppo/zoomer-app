import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/evaluation_type/evaluation_type.dart';
import 'package:msap/utils.dart';

class AddStudentForm extends StatefulWidget {
  const AddStudentForm({super.key});

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  String? standard;
  String? division;
  bool? male;
  final TextEditingController _nameController = TextEditingController();

  final List<String> standards = [
    'Nursery',
    'Kindergarten',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];

  final List<String> divisions = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
  ];

  void validateAndSubmit() {
    if (_nameController.text.isEmpty) {
      Utils.showShorterToast('Student Name is required');
      return;
    }
    if (standard == null) {
      Utils.showShorterToast('Standard is required');
      return;
    }
    if (division == null) {
      Utils.showShorterToast('Division is required');
      return;
    }
    if (male == null) {
      Utils.showShorterToast('Gender is required');
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const EvaluationTypeScreen()),
      (route) => false,
    );
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
                Text(
                  'Student Name',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E3D75),
                    fontSize: utils.subtitleSize,
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.01),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter student\'s full name',
                    hintStyle: GoogleFonts.roboto(
                      color: const Color(0xFF1E3D75),
                      fontWeight: FontWeight.w400,
                      fontSize: utils.subtitleSize * 0.85,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(utils.borderRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFF1E3D75),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.03),
                Text(
                  'Standard',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E3D75),
                    fontSize: utils.subtitleSize,
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.01),
                DropdownButtonFormField<String>(
                  decoration: utils.addStudentTextFieldDecoration(
                      'Enter standard of student'),
                  value: standard,
                  items: standards.map((standard) {
                    return DropdownMenuItem<String>(
                      value: standard,
                      child: Text(standard),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      standard = newValue;
                    });
                  },
                ),
                SizedBox(height: utils.screenHeight * 0.03),
                Text(
                  'Division',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E3D75),
                    fontSize: utils.subtitleSize,
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.01),
                DropdownButtonFormField<String>(
                  decoration: utils.addStudentTextFieldDecoration(
                      'Enter the division of the student'),
                  value: division,
                  items: divisions.map((division) {
                    return DropdownMenuItem<String>(
                      value: division,
                      child: Text(division),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      division = newValue;
                    });
                  },
                ),
                SizedBox(height: utils.screenHeight * 0.03),
                Text(
                  'Gender',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E3D75),
                    fontSize: utils.subtitleSize,
                  ),
                ),
                SizedBox(height: utils.screenHeight * 0.01),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          male == true ? male = null : male = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: utils.paddingHorizontal,
                          vertical: utils.paddingVertical,
                        ),
                        decoration: BoxDecoration(
                            color: male == true
                                ? utils.selectedContainer
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(utils.borderRadius),
                            border: male == true
                                ? null
                                : Border.all(color: const Color(0xFF1E3D75))),
                        child: Text(
                          'Male',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFF1E3D75),
                            fontSize: utils.subtitleSize * 0.8,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: utils.screenWidth * 0.03),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          male == true ? male = false : male = null;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: utils.paddingHorizontal,
                          vertical: utils.paddingVertical,
                        ),
                        decoration: BoxDecoration(
                            color: male == false
                                ? utils.selectedContainer
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(utils.borderRadius),
                            border: male == false
                                ? null
                                : Border.all(color: const Color(0xFF1E3D75))),
                        child: Text(
                          'Female',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFF1E3D75),
                            fontSize: utils.subtitleSize * 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
}
