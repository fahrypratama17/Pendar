class ScheduleModel {
  final String id;
  final String userId;
  final String taskName;
  final String priority;
  final DateTime deadline;
  final String notes;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ScheduleModel({
    required this.id,
    required this.userId,
    required this.taskName,
    required this.priority,
    required this.deadline,
    required this.notes,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      taskName: map['task_name'] as String? ?? '',
      priority: map['priority'] as String? ?? 'low',
      deadline: DateTime.parse(map['deadline'] as String),
      notes: map['notes'] as String? ?? '',
      isCompleted: map['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task_name': taskName,
      'priority': priority,
      'deadline': deadline.toIso8601String(),
      'notes': notes,
      'is_completed': isCompleted,
      'user_id': userId,
    };
  }
}
