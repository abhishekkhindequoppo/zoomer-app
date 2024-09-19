// import 'package:hive/hive.dart';

// class HiveService {
//   // Method to save data to Hive
//   Future<void> saveStudentData(List<Map<String, dynamic>> students) async {
//     final studentBox = await Hive.openBox('studentBox');
//     await studentBox.clear(); // Clear existing data before saving new data
//     for (var student in students) {
//       await studentBox.add(student);
//     }
//     print('Data saved successfully 1');
//   }

//   // Method to fetch data from Hive
//   Future<List<Map<String, dynamic>>> getStudentData() async {
//     final studentBox = await Hive.openBox('studentBox');
//     final students = studentBox.values.toList();
//     print('Data fetched successfully 2');
//     return students.cast<Map<String, dynamic>>();
//   }

//   // Method to save pending student data in Hive for offline mode
//   Future<void> savePendingStudentData(Map<String, dynamic> studentData) async {
//     final studentBox = await Hive.openBox('studentPendingBox');
//     await studentBox.add(studentData);
//     print('Pending data saved successfully 4');
//   }

//   // Method to save grades and divisions data in Hive
//   Future<void> saveGradesAndDivisions(List<String> grades,
//       List<String> divisions, List<dynamic> rawData) async {
//     final box = await Hive.openBox('gradesDivisionsBox');
//     await box.put('grades', grades);
//     await box.put('divisions', divisions);
//     await box.put('data', rawData);
//     print('Grades and divisions saved successfully 7');
//   }

//   // Method to get grades and divisions from Hive
//   Future<Map<String, dynamic>> getGradesAndDivisionsFromHive() async {
//     final box = await Hive.openBox('gradesDivisionsBox');
//     final grades = box.get('grades', defaultValue: []);
//     final divisions = box.get('divisions', defaultValue: []);
//     final rawData = box.get('data', defaultValue: []);
//     print('Grades and divisions fetched successfully 8');

//     return {
//       'grades': grades,
//       'divisions': divisions,
//       'data': rawData,
//     };
//   }

// }

import 'dart:convert';

import 'package:hive/hive.dart';

class HiveService {
  // Method to save data to Hive
  Future<void> saveStudentData(List<Map<String, dynamic>> students,
      String grade, String division) async {
    final studentBox = await Hive.openBox('studentBox');
    final key = '$grade-$division';
    await studentBox.put(key, students);
    print('Data saved successfully for $grade $division');
  }

  Future<List<Map<String, dynamic>>> getStudentData(
      String grade, String division) async {
    final studentBox = await Hive.openBox('studentBox');
    final key = '$grade-$division';
    final students = studentBox.get(key, defaultValue: []);

    print('Data fetched successfully for $grade $division');

    // Ensure that the fetched data is cast as List<Map<String, dynamic>>
    return List<Map<String, dynamic>>.from(
        (students as List).map((item) => Map<String, dynamic>.from(item)));
  }

  // Method to save pending student data in Hive for offline mode
  Future<void> savePendingStudentData(Map<String, dynamic> studentData) async {
    final studentBox = await Hive.openBox('studentPendingBox');
    await studentBox.add(studentData);
    print('Pending data saved successfully');
  }

  // Method to save grades and divisions data in Hive
  Future<void> saveGradesAndDivisions(List<String> grades,
      List<String> divisions, List<dynamic> rawData) async {
    final box = await Hive.openBox('gradesDivisionsBox');
    await box.put('grades', grades);
    await box.put('divisions', divisions);
    await box.put('data', rawData);
    print('Grades and divisions saved successfully');
  }

  // Method to get grades and divisions from Hive
  Future<Map<String, dynamic>> getGradesAndDivisionsFromHive() async {
    final box = await Hive.openBox('gradesDivisionsBox');
    final grades = box.get('grades', defaultValue: []);
    final divisions = box.get('divisions', defaultValue: []);
    final rawData = box.get('data', defaultValue: []);
    print('Grades and divisions fetched successfully');

    return {
      'grades': grades,
      'divisions': divisions,
      'data': rawData,
    };
  }

  // // Method to clear grades and divisions from Hive (if needed)
  // Future<void> clearGradesAndDivisions() async {
  //   final box = await Hive.openBox('gradesDivisionsBox');
  //   await box.clear();
  // }

  // // Method to retrieve pending student data from Hive (if needed)
  // Future<List<Map<String, dynamic>>> getPendingStudentData() async {
  //   final studentBox = await Hive.openBox('studentPendingBox');
  //   print('Pending data fetched successfully');
  //   return studentBox.values.cast<Map<String, dynamic>>().toList();
  // }

  // // Method to clear the pending student data from Hive after sync
  // Future<void> clearPendingData() async {
  //   final studentBox = await Hive.openBox('studentPendingBox');
  //   await studentBox.clear();
  //   print('Pending data cleared successfully');
  // }

  static const String checklistBoxName = 'checklistBox';

  // Method to save checklist data to Hive
  Future<void> saveChecklistData(List<Map<String, dynamic>> students,
      String schoolName, String grade, String division, int evalNumber) async {
    final checklistBox = await Hive.openBox(checklistBoxName);
    final key = '$schoolName-$grade-$division-$evalNumber';
    await checklistBox.put(key, jsonEncode(students));
    print(
        'Checklist data saved successfully for $schoolName $grade $division evaluation $evalNumber');
  }

  // Method to get checklist data from Hive
  Future<List<Map<String, dynamic>>> getChecklistData(
      String schoolName, String grade, String division, int evalNumber) async {
    final checklistBox = await Hive.openBox(checklistBoxName);
    final key = '$schoolName-$grade-$division-$evalNumber';
    final encodedData = checklistBox.get(key);

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      print(
          'Checklist data fetched successfully for $schoolName $grade $division evaluation $evalNumber');
      return decodedData.cast<Map<String, dynamic>>();
    }

    print(
        'No checklist data found for $schoolName $grade $division evaluation $evalNumber');
    return [];
  }
}
