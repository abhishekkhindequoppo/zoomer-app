import 'dart:developer';
import 'package:msap/services/golain_api_services.dart';
import 'package:get_it/get_it.dart';


Future<bool> submitEvaluationFromHive(
    Map<String, dynamic> evaluationData) async {
  final getIt = GetIt.instance;

  // final golainApiService = getIt<GolainApiService>();
  // Ensure that all required fields are present and valid
  final preparedData = {
    "school_name": evaluationData['school_name'] ?? '',
    "grade": evaluationData['grade'] ?? '',
    "division": evaluationData['division'] ?? '',
    "student_name": evaluationData['student_name'] ?? '',
    "roll_no": evaluationData['roll_no'] ?? 0,
    "attendance": evaluationData['attendance'] ?? '',
    "evaluation_number": evaluationData['evaluation_number'] ?? 1,
    "time_of_eval": evaluationData['time_of_eval'] ??
        DateTime.now().toIso8601String() + '+05:30',
    "year_of_eval": evaluationData['year_of_eval'] ??
        DateTime.now().toIso8601String() + '+05:30',
    "instructor_name": evaluationData['instructor_name'] ?? '',
    "image_id": evaluationData['image_id'] ?? '',
    "skipping": evaluationData['skipping'] ?? 0,
    "hit_balloon_up": evaluationData['hit_balloon_up'] ?? 0,
    "dribbling_ball_8": evaluationData['dribbling_ball_8'] ?? 0,
    "dribbling_ball_O": evaluationData['dribbling_ball_O'] ?? 0,
    "jump_symmetrically": evaluationData['jump_symmetrically'] ?? 0,
    "hop_9m_dominant_leg": evaluationData['hop_9m_dominant_leg'] ?? 0,
    "jump_asymmetrically": evaluationData['jump_asymmetrically'] ?? 0,
    "ball_bounce_and_catch": evaluationData['ball_bounce_and_catch'] ?? 0,
    "criss_cross_with_clap": evaluationData['criss_cross_with_clap'] ?? 0,
    "stand_on_dominant_leg": evaluationData['stand_on_dominant_leg'] ?? 0,
    "hop_9m_nondominant_leg": evaluationData['hop_9m_nondominant_leg'] ?? 0,
    "step_down_dominant_leg": evaluationData['step_down_dominant_leg'] ?? '',
    "step_over_dominant_leg": evaluationData['step_over_dominant_leg'] ?? '',
    "criss_cross_leg_forward": evaluationData['criss_cross_leg_forward'] ?? 0,
    "jumping_jacks_with_clap": evaluationData['jumping_jacks_with_clap'] ?? 0,
    "criss_cross_without_clap": evaluationData['criss_cross_without_clap'] ?? 0,
    "hop_forward_dominant_leg": evaluationData['hop_forward_dominant_leg'] ?? 0,
    "stand_on_nondominant_leg": evaluationData['stand_on_nondominant_leg'] ?? 0,
    "step_down_nondominant_leg":
        evaluationData['step_down_nondominant_leg'] ?? '',
    "step_over_nondominant_leg":
        evaluationData['step_over_nondominant_leg'] ?? '',
    "jumping_jacks_without_clap":
        evaluationData['jumping_jacks_without_clap'] ?? 0,
    "hop_forward_nondominant_leg":
        evaluationData['hop_forward_nondominant_leg'] ?? 0,
    "forward_backward_spread_legs":
        evaluationData['forward_backward_spread_legs'] ?? 0,
    "alternate_forward_backward_legs":
        evaluationData['alternate_forward_backward_legs'] ?? 0,
  };

  try {
    // Call the API to submit the data
    final apiService = getIt<GolainApiService>();
    final result = await apiService.postStudentEvaluation(preparedData);

    if (result) {
      log("Successfully submitted evaluation data.");
    } else {
      log("Failed to submit evaluation data.");
    }

    return result;
  } catch (error) {
    log("Error submitting evaluation data: $error");
    return false;
  }
}
