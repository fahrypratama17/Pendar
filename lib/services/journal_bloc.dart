import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'journal_event.dart';
import 'journal_state.dart';
import '../models/journal_model.dart';
import '../utils/error_translator.dart';
import 'dart:developer' as dev;

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  JournalBloc() : super(JournalInitial()) {
    on<JournalLoadRequested>(_onLoadRequested);
    on<JournalAddRequested>(_onAddRequested);
    on<JournalUpdateRequested>(_onUpdateRequested);
    on<JournalDeleteRequested>(_onDeleteRequested);
    on<JournalAutoSaveRequested>(_onAutoSaveRequested);
  }

  Future<void> _onLoadRequested(
      JournalLoadRequested event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        emit(const JournalFailure('User not authenticated'));
        return;
      }
      final response = await _supabaseClient
          .from('journals')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
      final List<dynamic> data = response;
      final journals = data
          .map((e) => JournalModel.fromMap(e as Map<String, dynamic>))
          .toList();
      emit(JournalLoadSuccess(journals));
    } catch (e) {
      emit(JournalFailure(ErrorTranslator.translate(e)));
    }
  }

  Future<void> _onAddRequested(
      JournalAddRequested event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        emit(const JournalFailure('User not authenticated'));
        return;
      }
      await _supabaseClient.from('journals').insert({
        'title': event.title,
        'content': event.content,
        'mood': event.mood,
        'user_id': user.id,
      });
      emit(JournalOperationSuccess());
    } catch (e) {
      emit(JournalFailure(ErrorTranslator.translate(e)));
    }
  }

  Future<void> _onUpdateRequested(
      JournalUpdateRequested event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
      await _supabaseClient.from('journals').update({
        'title': event.title,
        'content': event.content,
        'mood': event.mood,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', event.id);
      emit(JournalOperationSuccess());
    } catch (e) {
      emit(JournalFailure(ErrorTranslator.translate(e)));
    }
  }

  Future<void> _onDeleteRequested(
      JournalDeleteRequested event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
      await _supabaseClient.from('journals').delete().eq('id', event.id);
      emit(JournalOperationSuccess());
    } catch (e) {
      emit(JournalFailure(ErrorTranslator.translate(e)));
    }
  }

  Future<void> _onAutoSaveRequested(
      JournalAutoSaveRequested event, Emitter<JournalState> emit) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return;
      }
      if (event.id == null || event.id!.isEmpty) {
        final response = await _supabaseClient.from('journals').insert({
          'title': event.title,
          'content': event.content,
          'mood': event.mood,
          'user_id': user.id,
        }).select('id').single();
        final String newId = response['id'] as String;
        emit(JournalAutoSaveSuccess(newId));
      } else {
        await _supabaseClient.from('journals').update({
          'title': event.title,
          'content': event.content,
          'mood': event.mood,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', event.id!);
        emit(JournalAutoSaveSuccess(event.id!));
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }
}
