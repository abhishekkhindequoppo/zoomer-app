part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState {}

class AssessmentInitial extends AssessmentState {}

class AIAssessment extends AssessmentState {}

class ManualAssessment extends AssessmentState {}
