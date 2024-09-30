import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:msap/services/offline_sync_helper.dart';
import 'package:msap/utils.dart';
import '../models/student.dart';
import 'dart:developer';
import 'hive_service.dart'; // Import the HiveService class

class GolainApiService {
  late final Dio _dio;
  String _bearerToken = "";
  String orgId = dotenv.env['ORG_ID']!;

  GolainApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ));
  }

  void setUserToken(String token) {
    _bearerToken = token;
    // Update Dio headers whenever the token is set
    _dio.options.headers['Org-ID'] = orgId;
    _dio.options.headers['Authorization'] = 'Bearer $_bearerToken';
    log("Bearer token set: $_bearerToken");
  }

  // post Student data
  Future<bool> postStudentData(Student student) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hiveService = HiveService(); // Create instance of HiveService

    if (connectivityResult == ConnectivityResult.none) {
      // Offline mode: store data in Hive
      await hiveService.savePendingStudentData(student.toJson());
      return true;
    } else {
      // Online mode: Post data to API
      try {
        // Online case: Post data to API
        log("Posting student data: ${student.toJson()}");
        // log("URL: " + dotenv.env['BASE_URL']! + 'add_student/');
        final response =
            await _dio.post('add_student/', data: student.toJson());
        return response.statusCode == 200;
      } on DioException catch (e) {
        log('Error posting student data: ${e.message}');
        return false;
      }
    }
  }

  Future<List<Map<String, dynamic>>> getStudentList(
      String schoolName, String grade, String division) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hiveService = HiveService();

    if (connectivityResult == ConnectivityResult.none) {
      // Offline mode: fetch data from Hive
      log('Offline mode: Fetching data from Hive');
      return await hiveService.getStudentData(grade, division);
    } else {
      // Online mode: fetch data from API and store it in Hive
      try {
        final response = await _dio.get('/student_list/', queryParameters: {
          'school_name': schoolName,
          'grade': grade,
          'division': division,
        });

        if (response.statusCode == 200) {
          final data = response.data;
          if (data['ok'] == 1) {
            final studentList = List<Map<String, dynamic>>.from(data['data']);
            // Store the fetched data in Hive
            await hiveService.saveStudentData(studentList, grade, division);
            log('Online mode: Data fetched from API and saved to Hive');
            return studentList;
          } else {
            throw Exception('API returned ok: 0');
          }
        } else {
          throw Exception('Failed to load student list');
        }
      } on DioException catch (e) {
        log('Error getting student list from API: ${e.message}');
        // If API call fails, try to fetch data from Hive as a fallback
        log('Falling back to Hive data');
        return await hiveService.getStudentData(grade, division);
      }
    }
  }

  /// Fetches grades and divisions from the backend for the given school.
  Future<Map<String, dynamic>> getGradesAndDivisions(String schoolName) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hiveService = HiveService(); // Create instance of HiveService

    if (connectivityResult == ConnectivityResult.none) {
      // Offline mode: fetch data from Hive
      log("Offline mode: fetching data from Hive");
      return await hiveService.getGradesAndDivisionsFromHive();
    } else {
      // Online mode: fetch data from API and store it in Hive
      log("Fetching grades and divisions for school: $schoolName");
      try {
        log("Headers: ${_dio.options.headers}");
        final response = await _dio.get('/grades_divisions/', queryParameters: {
          'school_name': schoolName,
        });

        if (response.statusCode == 200) {
          final data = response.data;
          if (data['ok'] == 1) {
            final List<dynamic> rawData = data['data'];
            final Set<String> grades = {};
            final Set<String> divisions = {};

            for (var item in rawData) {
              grades.add(item['grade']);
              divisions.add(item['division']);
            }

            // Define the custom order for grades
            final List<String> gradeOrder = [
              'Nursery',
              'LKG',
              'SKG',
              'Grade 1',
              'Grade 2',
              'Grade 3',
              'Grade 4',
              'Grade 5',
              'Grade 6',
              'Grade 7',
              'Grade 8',
              'Grade 9',
              'Grade 10',
              'Grade 11',
              'Grade 12'
            ];

            // Sort grades based on the custom order
            final List<String> sortedGrades = grades.toList()
              ..sort((a, b) {
                int indexA = gradeOrder.indexOf(a);
                int indexB = gradeOrder.indexOf(b);
                if (indexA == -1)
                  indexA = gradeOrder.length; // Unsorted grades go to the end
                if (indexB == -1) indexB = gradeOrder.length;
                return indexA.compareTo(indexB);
              });

            // Sort divisions alphabetically
            final List<String> sortedDivisions = divisions.toList()..sort();

            // Store the data in Hive for offline access
            await hiveService.saveGradesAndDivisions(
                sortedGrades, sortedDivisions, rawData);

            log("Grades and divisions fetched successfully from API");
            return {
              'grades': sortedGrades,
              'divisions': sortedDivisions,
              'data': rawData,
            };
          } else {
            throw Exception('API returned ok: 0');
          }
        } else {
          throw Exception('Failed to load grades and divisions');
        }
      } on DioException catch (e) {
        log('Error getting grades and divisions: ${e.message}');
        if (e.error is SocketException) {
          // Offline mode: fallback to Hive if DNS resolution fails
          log('Failed to resolve API host, falling back to offline mode');
          return await hiveService.getGradesAndDivisionsFromHive();
        }

        // Handle other DioExceptions if necessary
        log('API request failed, returning empty data');
        return {
          'grades': [],
          'divisions': [],
          'data': [],
        };
      } catch (e) {
        log('Unexpected error: $e');
        return {
          'grades': [],
          'divisions': [],
          'data': [],
        };
      }
    }
  }

  Future<bool> postStudentEvaluation(
      Map<String, dynamic> evaluationData) async {
    // Check internet connection
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      // Internet is available, post the evaluation data to the API
      try {
        log("Posting student evaluation data: $evaluationData");
        final response =
            await _dio.post('post_student_eval/', data: evaluationData);

        if (response.statusCode == 200) {
          log('Successfully posted evaluation data.');
          return true;
        } else {
          throw Exception('Failed to post student evaluation');
        }
      } on DioException catch (e) {
        log('Error posting student evaluation: ${e.message}');
        log('Error response: ${e.response?.data}');
        return false;
      }
    } else {
      // No internet connection, store the evaluation data in Hive for later
      log('No internet connection, storing evaluation data locally in Hive');
      var box = await Hive.openBox('evaluationBox');

      // Save the evaluation data with a timestamp or unique ID to sync later
      await box.add(evaluationData);

      log('Evaluation data saved locally in Hive.');
      return true; // Data saved locally for future sync
    }
  }

  Future<List<Map<String, dynamic>>> getChecklistStudents(
      String schoolName, String grade, String division, int evalNumber) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hiveService = HiveService();

    if (connectivityResult == ConnectivityResult.none) {
      // Offline mode: fetch data from Hive
      log('Offline mode: Fetching checklist data from Hive');
      return await hiveService.getChecklistData(
          schoolName, grade, division, evalNumber);
    } else {
      // Online mode: fetch data from API and store it in Hive
      try {
        log('Getting checklist students from API');
        final response =
            await _dio.get('get_checklist_students/', queryParameters: {
          'school_name': schoolName,
          'division': division,
          'grade': grade,
          'eval_number': evalNumber,
        });

        if (response.statusCode == 200) {
          final data = response.data;
          if (data['ok'] == 1) {
            final List<dynamic> students = data['data'];
            final List<Map<String, dynamic>> typedStudents =
                students.cast<Map<String, dynamic>>().toList();

            // Store the fetched data in Hive
            await hiveService.saveChecklistData(
                typedStudents, schoolName, grade, division, evalNumber);
            log('Online mode: Checklist data fetched from API and saved to Hive');

            return typedStudents;
          } else {
            throw Exception('API returned ok: 0');
          }
        } else {
          throw Exception('Failed to load checklist students');
        }
      } on DioException catch (e) {
        log('Error getting checklist students from API: ${e.message}');
        // If API call fails, try to fetch data from Hive as a fallback
        log('Falling back to Hive data for checklist');
        return await hiveService.getChecklistData(
            schoolName, grade, division, evalNumber);
      }
    }
  }

  Future<void> syncEvaluationDataWithServer() async {
    try {
      // Open the Hive box
      var box = await Hive.openBox('evaluationData');

      // Retrieve the evaluation data from Hive
      var evaluationData = box.get('evaluationRecord');
      log("Retrieved evaluation data from Hive: $evaluationData");

      // Check if there is data to sync
      if (evaluationData != null) {
        // Log the type of data retrieved
        log("Type of evaluationData: ${evaluationData.runtimeType}");

        // Check if the data is a Map
        if (evaluationData is Map<String, dynamic>) {
          // Proceed with processing
          final result = await submitEvaluationFromHive(evaluationData);

          if (result) {
            Utils.showSuccess('Evaluation data synced successfully.');
            // Optionally, you could remove the individual record here
          } else {
            log("Failed to sync evaluation data with server, keeping it in Hive for retry.");
          }

          // Clear the Hive box if the record is successfully processed
          await box.delete('evaluationRecord');
        } else {
          log("Unexpected data structure in evaluationRecord. Expected Map<String, dynamic>.");
        }
      } else {
        log("No evaluation data to sync.");
      }
    } catch (error) {
      // Handle any unexpected errors gracefully
      log("Error syncing evaluation data: $error");
    }
  }

  /// post student list to the api
  Future<void> syncHiveDataWithApi() async {
    final getIt = GetIt.instance;
    final golainApiService = getIt<GolainApiService>();

    // Check internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    final isConnected = connectivityResult != ConnectivityResult.none;

    if (!isConnected) {
      // No internet connection
      Utils.showShorterToast('No internet connection. Sync not possible.');
      return;
    }

    // Open the Hive box
    final box = await Hive.openBox('studentData');

    // Get all grade and division keys from the box
    final keys = box.keys.where((key) => key is String).toList();

    for (final key in keys) {
      final List<Student> students = List<Student>.from(box.get(key) ?? []);

      if (students.isNotEmpty) {
        for (final student in students) {
          // Post each student data to the API
          bool success = await golainApiService.postStudentData(student);

          if (success) {
            // Clear the box entry after successful sync
            box.delete(key);
            Utils.showShorterToast('Data synced successfully for $key');
          } else {
            Utils.showShorterToast('Failed to sync data for $key');
          }
        }
      }
    }
  }
}
