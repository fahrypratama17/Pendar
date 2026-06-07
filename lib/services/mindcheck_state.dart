import 'package:pendar/models/mindcheck_result_model.dart';

enum MindCheckStatus { initial, submitting, success, error }

class MindCheckState {
  final int mentalHealthIndex;           // Step 1: 0 to 2
  final List<int> depressionAnswers;     // Step 2: 7 questions, each score 0-3
  final List<int> anxietyAnswers;        // Step 3: 7 questions, each score 0-3
  final List<int> stressAnswers;         // Step 4: 7 questions, each score 0-3
  final int sleepHours;                  // Step 5: Sleep hours
  final int studyHours;                  // Step 5: Study hours

  final MindCheckStatus status;
  final MindCheckResultModel? result;
  final String? errorMessage;

  MindCheckState({
    required this.mentalHealthIndex,
    required this.depressionAnswers,
    required this.anxietyAnswers,
    required this.stressAnswers,
    required this.sleepHours,
    required this.studyHours,
    required this.status,
    this.result,
    this.errorMessage,
  });

  factory MindCheckState.initial() {
    return MindCheckState(
      mentalHealthIndex: 0,
      depressionAnswers: List.filled(7, 0),
      anxietyAnswers: List.filled(7, 0),
      stressAnswers: List.filled(7, 0),
      sleepHours: 7, // Default sleep hours
      studyHours: 4, // Default study hours
      status: MindCheckStatus.initial,
    );
  }

  // Calculate scores (sum of 7 questions multiplied by 2, as per DASS-21 standard)
  int get depressionScore => depressionAnswers.reduce((a, b) => a + b) * 2;
  int get anxietyScore => anxietyAnswers.reduce((a, b) => a + b) * 2;
  int get stressScore => stressAnswers.reduce((a, b) => a + b) * 2;

  MindCheckState copyWith({
    int? mentalHealthIndex,
    List<int>? depressionAnswers,
    List<int>? anxietyAnswers,
    List<int>? stressAnswers,
    int? sleepHours,
    int? studyHours,
    MindCheckStatus? status,
    MindCheckResultModel? result,
    String? errorMessage,
  }) {
    return MindCheckState(
      mentalHealthIndex: mentalHealthIndex ?? this.mentalHealthIndex,
      depressionAnswers: depressionAnswers ?? this.depressionAnswers,
      anxietyAnswers: anxietyAnswers ?? this.anxietyAnswers,
      stressAnswers: stressAnswers ?? this.stressAnswers,
      sleepHours: sleepHours ?? this.sleepHours,
      studyHours: studyHours ?? this.studyHours,
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
