// void validateAndSubmit() async {
//     // Validate if student name is empty
//     if (_nameController.text.isEmpty) {
//       Utils.showShorterToast('Student Name is required');
//       return;
//     }

//     // Parse roll number or default to 0 if the field is empty
//     int rollNo = _rollNoController.text.isEmpty
//         ? 0
//         : int.tryParse(_rollNoController.text) ?? 0;

//     // Retrieve school details from shared preferences
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? schoolName = prefs.getString('school_name') ?? '';
//     String? grade = prefs.getString('selectedGrade') ?? '';
//     String? division = prefs.getString('selectedDivision') ?? '';

//     // Create a Student object
//     final student = Student(
//       schoolName: schoolName,
//       grade: grade,
//       division: division,
//       studentName: _nameController.text,
//       rollNo: rollNo,
//     );

//     // Check internet connectivity
//     final connectivityResult = await Connectivity().checkConnectivity();
//     final isConnected = connectivityResult == ConnectivityResult.none;

//     if (isConnected) {
//       // Post student data to the API
//       bool success = await golainApiService.postStudentData(student);
//       log("Posting student data to API: $success");

//       if (success) {
//         Utils.showShorterToast('Student added successfully');
//         // Navigate to the appropriate screen based on the 'type'
//         String? type = prefs.getString('type');

//         if (type == 's') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const ManualStudentsList(),
//             ),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const ManualEvaluationType(),
//             ),
//           );
//         }
//       } else {
//         Utils.showShorterToast('Failed to add student');
//       }
//     } else {
//       // Store student data in Hive for offline use
//       final box = await Hive.openBox('studentData');
//       final gradeDivisionKey = '$grade-$division';

//       // Check if the grade and division box exists
//       if (!box.containsKey(gradeDivisionKey)) {
//         box.put(gradeDivisionKey, []);
//       }
//       log("Storing student data in Hive: $student");

//       // Add student data to the respective list
//       final List<Student> students =
//           List<Student>.from(box.get(gradeDivisionKey));
//       students.add(student);
//       box.put(gradeDivisionKey, students);
//       log("Successfully stored student data in Hive");

//       Utils.showShorterToast(
//           'Student data stored locally. Will sync when online.');

//       // Navigate to the appropriate screen after storing in Hive
//       String? type = prefs.getString('type');

//       if (type == 's') {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const ManualStudentsList(),
//           ),
//         );
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const ManualEvaluationType(),
//           ),
//         );
//       }
//     }
//   }