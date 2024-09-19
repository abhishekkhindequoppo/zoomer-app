import 'package:hive/hive.dart';



part 'student.g.dart';


@HiveType(typeId: 0)
class Student extends HiveObject{
	@HiveField(0)
  final String schoolName;
	@HiveField(1)
  final String grade;
	@HiveField(2)
  final String division;
	@HiveField(3)
  final String studentName;
	@HiveField(4)
  final int rollNo;

  Student({
    required this.schoolName,
    required this.grade,
    required this.division,
    required this.studentName,
    required this.rollNo,
  });

	// @HiveField(StudentFields.)
  Map<String, dynamic> toJson() {
    return {
      'school_name': schoolName,
      'grade': grade,
      'division': division,
      'student_name': studentName,
      'roll_no': rollNo,
    };
  }
  
}




