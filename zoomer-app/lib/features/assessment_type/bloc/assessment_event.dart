part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent {}

class AIAssessmentEvent extends AssessmentEvent {}

class ManualAssessmentEvent extends AssessmentEvent {}
