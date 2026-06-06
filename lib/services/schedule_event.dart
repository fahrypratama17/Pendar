import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class ScheduleLoadRequested extends ScheduleEvent {}

class ScheduleAddRequested extends ScheduleEvent {
  final String taskName;
  final String priority;
  final DateTime deadline;
  final String notes;

  const ScheduleAddRequested({
    required this.taskName,
    required this.priority,
    required this.deadline,
    required this.notes,
  });

  @override
  List<Object?> get props => [taskName, priority, deadline, notes];
}

class ScheduleUpdateRequested extends ScheduleEvent {
  final String id;
  final String taskName;
  final String priority;
  final DateTime deadline;
  final String notes;
  final bool isCompleted;

  const ScheduleUpdateRequested({
    required this.id,
    required this.taskName,
    required this.priority,
    required this.deadline,
    required this.notes,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, taskName, priority, deadline, notes, isCompleted];
}

class ScheduleToggleCompleteRequested extends ScheduleEvent {
  final String id;
  final bool isCompleted;

  const ScheduleToggleCompleteRequested({
    required this.id,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, isCompleted];
}

class ScheduleDeleteRequested extends ScheduleEvent {
  final String id;

  const ScheduleDeleteRequested({required this.id});

  @override
  List<Object?> get props => [id];
}
