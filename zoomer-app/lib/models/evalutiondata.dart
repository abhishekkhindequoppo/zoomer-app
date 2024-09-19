import 'package:hive/hive.dart';



part 'evalutiondata.g.dart';

@HiveType(typeId: 1)
class EvaluationData {
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
  @HiveField(5)
  final int attendance;
  @HiveField(6)
  final int evaluationNumber;
  @HiveField(7)
  final DateTime timeOfEval;
  @HiveField(8)
  final int yearOfEval;
  @HiveField(9)
  final String instructorName;
  @HiveField(10)
  final String imageId;
  @HiveField(11)
  final int skipping;
  @HiveField(12)
  final int hitBalloonUp;
  @HiveField(13)
  final int dribblingBall8;
  @HiveField(14)
  final int dribblingBallO;
  @HiveField(15)
  final int jumpSymmetrically;
  @HiveField(16)
  final int hop9mDominantLeg;
  @HiveField(17)
  final int jumpAsymmetrically;
  @HiveField(18)
  final int ballBounceAndCatch;
  @HiveField(19)
  final int crissCrossWithClap;
  @HiveField(20)
  final int standOnDominantLeg;
  @HiveField(21)
  final int hop9mNondominantLeg;
  @HiveField(22)
  final String stepDownDominantLeg;
  @HiveField(23)
  final String stepOverDominantLeg;
  @HiveField(24)
  final int crissCrossLegForward;
  @HiveField(25)
  final int jumpingJacksWithClap;
  @HiveField(26)
  final int crissCrossWithoutClap;
  @HiveField(27)
  final int hopForwardDominantLeg;
  @HiveField(28)
  final int standOnNondominantLeg;
  @HiveField(29)
  final String stepDownNondominantLeg;
  @HiveField(30)
  final String stepOverNondominantLeg;
  @HiveField(31)
  final int jumpingJacksWithoutClap;
  @HiveField(32)
  final int hopForwardNondominantLeg;
  @HiveField(33)
  final int forwardBackwardSpreadLegs;
  @HiveField(34)
  final int alternateForwardBackwardLegs;

  EvaluationData({
    required this.schoolName,
    required this.grade,
    required this.division,
    required this.studentName,
    required this.rollNo,
    required this.attendance,
    required this.evaluationNumber,
    required this.timeOfEval,
    required this.yearOfEval,
    required this.instructorName,
    required this.imageId,
    required this.skipping,
    required this.hitBalloonUp,
    required this.dribblingBall8,
    required this.dribblingBallO,
    required this.jumpSymmetrically,
    required this.hop9mDominantLeg,
    required this.jumpAsymmetrically,
    required this.ballBounceAndCatch,
    required this.crissCrossWithClap,
    required this.standOnDominantLeg,
    required this.hop9mNondominantLeg,
    required this.stepDownDominantLeg,
    required this.stepOverDominantLeg,
    required this.crissCrossLegForward,
    required this.jumpingJacksWithClap,
    required this.crissCrossWithoutClap,
    required this.hopForwardDominantLeg,
    required this.standOnNondominantLeg,
    required this.stepDownNondominantLeg,
    required this.stepOverNondominantLeg,
    required this.jumpingJacksWithoutClap,
    required this.hopForwardNondominantLeg,
    required this.forwardBackwardSpreadLegs,
    required this.alternateForwardBackwardLegs,
  });

  factory EvaluationData.fromMap(Map<String, dynamic> map) {
    return EvaluationData(
      schoolName: map['school_name'] as String,
      grade: map['grade'] as String,
      division: map['division'] as String,
      studentName: map['student_name'] as String,
      rollNo: map['roll_no'] as int,
      attendance: map['attendance'] as int,
      evaluationNumber: map['evaluation_number'] as int,
      timeOfEval: DateTime.parse(map['time_of_eval'] as String),
      yearOfEval: map['year_of_eval'] as int,
      instructorName: map['instructor_name'] as String,
      imageId: map['image_id'] as String,
      skipping: map['skipping'] as int,
      hitBalloonUp: map['hit_balloon_up'] as int,
      dribblingBall8: map['dribbling_ball_8'] as int,
      dribblingBallO: map['dribbling_ball_O'] as int,
      jumpSymmetrically: map['jump_symmetrically'] as int,
      hop9mDominantLeg: map['hop_9m_dominant_leg'] as int,
      jumpAsymmetrically: map['jump_asymmetrically'] as int,
      ballBounceAndCatch: map['ball_bounce_and_catch'] as int,
      crissCrossWithClap: map['criss_cross_with_clap'] as int,
      standOnDominantLeg: map['stand_on_dominant_leg'] as int,
      hop9mNondominantLeg: map['hop_9m_nondominant_leg'] as int,
      stepDownDominantLeg: map['step_down_dominant_leg'] as String,
      stepOverDominantLeg: map['step_over_dominant_leg'] as String,
      crissCrossLegForward: map['criss_cross_leg_forward'] as int,
      jumpingJacksWithClap: map['jumping_jacks_with_clap'] as int,
      crissCrossWithoutClap: map['criss_cross_without_clap'] as int,
      hopForwardDominantLeg: map['hop_forward_dominant_leg'] as int,
      standOnNondominantLeg: map['stand_on_nondominant_leg'] as int,
      stepDownNondominantLeg: map['step_down_nondominant_leg'] as String,
      stepOverNondominantLeg: map['step_over_nondominant_leg'] as String,
      jumpingJacksWithoutClap: map['jumping_jacks_without_clap'] as int,
      hopForwardNondominantLeg: map['hop_forward_nondominant_leg'] as int,
      forwardBackwardSpreadLegs: map['forward_backward_spread_legs'] as int,
      alternateForwardBackwardLegs:
          map['alternate_forward_backward_legs'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'school_name': schoolName,
      'grade': grade,
      'division': division,
      'student_name': studentName,
      'roll_no': rollNo,
      'attendance': attendance,
      'evaluation_number': evaluationNumber,
      'time_of_eval': timeOfEval.toIso8601String(),
      'year_of_eval': yearOfEval,
      'instructor_name': instructorName,
      'image_id': imageId,
      'skipping': skipping,
      'hit_balloon_up': hitBalloonUp,
      'dribbling_ball_8': dribblingBall8,
      'dribbling_ball_O': dribblingBallO,
      'jump_symmetrically': jumpSymmetrically,
      'hop_9m_dominant_leg': hop9mDominantLeg,
      'jump_asymmetrically': jumpAsymmetrically,
      'ball_bounce_and_catch': ballBounceAndCatch,
      'criss_cross_with_clap': crissCrossWithClap,
      'stand_on_dominant_leg': standOnDominantLeg,
      'hop_9m_nondominant_leg': hop9mNondominantLeg,
      'step_down_dominant_leg': stepDownDominantLeg,
      'step_over_dominant_leg': stepOverDominantLeg,
      'criss_cross_leg_forward': crissCrossLegForward,
      'jumping_jacks_with_clap': jumpingJacksWithClap,
      'criss_cross_without_clap': crissCrossWithoutClap,
      'hop_forward_dominant_leg': hopForwardDominantLeg,
      'stand_on_nondominant_leg': standOnNondominantLeg,
      'step_down_nondominant_leg': stepDownNondominantLeg,
      'step_over_nondominant_leg': stepOverNondominantLeg,
      'jumping_jacks_without_clap': jumpingJacksWithoutClap,
      'hop_forward_nondominant_leg': hopForwardNondominantLeg,
      'forward_backward_spread_legs': forwardBackwardSpreadLegs,
      'alternate_forward_backward_legs': alternateForwardBackwardLegs,
    };
  }
}
