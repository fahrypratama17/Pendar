import 'package:equatable/equatable.dart';
import '../models/schedule_model.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoadSuccess extends ScheduleState {
  final List<ScheduleModel> schedules;

  const ScheduleLoadSuccess(this.schedules);

  @override
  List<Object?> get props => [schedules];
}

class ScheduleOperationSuccess extends ScheduleState {}

class ScheduleFailure extends ScheduleState {
  final String message;

  const ScheduleFailure(this.message);

  @override
  List<Object?> get props => [message];
}
