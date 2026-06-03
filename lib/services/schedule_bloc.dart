import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';
import '../models/schedule_model.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleLoadRequested>(_onLoadRequested);
    on<ScheduleAddRequested>(_onAddRequested);
    on<ScheduleUpdateRequested>(_onUpdateRequested);
    on<ScheduleToggleCompleteRequested>(_onToggleCompleteRequested);
    on<ScheduleDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
      ScheduleLoadRequested event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        emit(const ScheduleFailure('User not authenticated'));
        return;
      }
      final response = await _supabaseClient
          .from('schedule')
          .select()
          .eq('user_id', user.id)
          .order('deadline', ascending: true);
      final List<dynamic> data = response;
      final schedules = data
          .map((e) => ScheduleModel.fromMap(e as Map<String, dynamic>))
          .toList();
      emit(ScheduleLoadSuccess(schedules));
    } catch (e) {
      emit(ScheduleFailure(e.toString()));
    }
  }

  Future<void> _onAddRequested(
      ScheduleAddRequested event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        emit(const ScheduleFailure('User not authenticated'));
        return;
      }
      await _supabaseClient.from('schedule').insert({
        'task_name': event.taskName,
        'priority': event.priority,
        'deadline': event.deadline.toIso8601String(),
        'notes': event.notes,
        'user_id': user.id,
      });
      emit(ScheduleOperationSuccess());
    } catch (e) {
      emit(ScheduleFailure(e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
      ScheduleUpdateRequested event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      await _supabaseClient.from('schedule').update({
        'task_name': event.taskName,
        'priority': event.priority,
        'deadline': event.deadline.toIso8601String(),
        'notes': event.notes,
        'is_completed': event.isCompleted,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', event.id);
      emit(ScheduleOperationSuccess());
    } catch (e) {
      emit(ScheduleFailure(e.toString()));
    }
  }

  Future<void> _onToggleCompleteRequested(
      ScheduleToggleCompleteRequested event, Emitter<ScheduleState> emit) async {
    try {
      await _supabaseClient.from('schedule').update({
        'is_completed': event.isCompleted,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', event.id);
      add(ScheduleLoadRequested());
    } catch (e) {
      emit(ScheduleFailure(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
      ScheduleDeleteRequested event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      await _supabaseClient.from('schedule').delete().eq('id', event.id);
      emit(ScheduleOperationSuccess());
    } catch (e) {
      emit(ScheduleFailure(e.toString()));
    }
  }
}
