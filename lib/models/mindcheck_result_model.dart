class MindCheckResultModel {
  final String id;
  final DateTime createdAt;
  final String userId;
  final int mentalHealthIndex;
  final int depressionScore;
  final int anxietyScore;
  final int stressScore;
  final int sleepHours;
  final int studyHours;
  final int focusLevelPct;
  final int burnoutLevelPct;
  final bool isBurnout;
  final String analysisMessage;

  const MindCheckResultModel({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.mentalHealthIndex,
    required this.depressionScore,
    required this.anxietyScore,
    required this.stressScore,
    required this.sleepHours,
    required this.studyHours,
    required this.focusLevelPct,
    required this.burnoutLevelPct,
    required this.isBurnout,
    required this.analysisMessage,
  });

  /// Factory for the POST /mind-checks response
  factory MindCheckResultModel.fromPostResponse(Map<String, dynamic> map) {
    final analysisResult = map['analysis_result'] as Map<String, dynamic>?;
    final isBurnout = analysisResult?['is_burnout'] as bool? ?? false;
    final defaultMsg = isBurnout
        ? "It looks like you're reaching your limit. Please prioritize rest."
        : "You're doing great! Your focus is high today.";

    return MindCheckResultModel(
      id: map['id'] as String? ?? '',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'] as String) 
          : DateTime.now(),
      userId: map['user_id'] as String? ?? '',
      mentalHealthIndex: map['mental_health_index'] as int? ?? 0,
      depressionScore: map['depression_score'] as int? ?? 0,
      anxietyScore: map['anxiety_score'] as int? ?? 0,
      stressScore: map['stress_score'] as int? ?? 0,
      sleepHours: map['sleep_hours'] as int? ?? 0,
      studyHours: map['study_hours'] as int? ?? 0,
      focusLevelPct: analysisResult?['focus_level_pct'] as int? ?? 0,
      burnoutLevelPct: analysisResult?['burnout_level_pct'] as int? ?? 0,
      isBurnout: isBurnout,
      analysisMessage: analysisResult?['analysis_message'] as String? ?? defaultMsg,
    );
  }

  /// Factory for the GET /mind-checks response (which returns raw database rows)
  factory MindCheckResultModel.fromDbRow(Map<String, dynamic> map) {
    final isBurnout = map['is_burnout'] as bool? ?? false;
    final defaultMsg = isBurnout
        ? "It looks like you're reaching your limit. Please prioritize rest."
        : "You're doing great! Your focus is high today.";

    return MindCheckResultModel(
      id: map['id'] as String? ?? '',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'] as String) 
          : DateTime.now(),
      userId: map['user_id'] as String? ?? '',
      mentalHealthIndex: map['mental_health_index'] as int? ?? 0,
      depressionScore: map['depression_score'] as int? ?? 0,
      anxietyScore: map['anxiety_score'] as int? ?? 0,
      stressScore: map['stress_score'] as int? ?? 0,
      sleepHours: map['sleep_hours'] as int? ?? 0,
      studyHours: map['study_hours'] as int? ?? 0,
      focusLevelPct: map['focus_level_pct'] as int? ?? 0,
      burnoutLevelPct: map['burnout_level_pct'] as int? ?? 0,
      isBurnout: isBurnout,
      analysisMessage: defaultMsg,
    );
  }
}
