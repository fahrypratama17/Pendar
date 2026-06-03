import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'auth_event.dart';
import 'auth_state.dart';
import '../models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  AuthBloc() : super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AuthAppStarted event, Emitter<AuthState> emit) async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) {
        emit(AuthUnauthenticated());
        return;
      }
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        emit(AuthUnauthenticated());
        return;
      }
      final userData = await _supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .single();
      emit(AuthAuthenticated(UserModel.fromMap(userData, user.email ?? '')));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );
      if (response.user == null) {
        emit(const AuthFailure('Login failed: User not found'));
        return;
      }
      final userData = await _supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      emit(AuthAuthenticated(UserModel.fromMap(userData, response.user!.email ?? '')));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _supabaseClient.auth.signUp(
        email: event.email,
        password: event.password,
        data: {
          'full_name': event.fullName,
          'university': event.university,
        },
      );
      if (response.user == null) {
        emit(const AuthFailure('Registration failed: User not created'));
        return;
      }
      if (response.session == null) {
        emit(const AuthFailure('Registration successful! Please confirm your email address.'));
        return;
      }
      final userData = await _supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      emit(AuthAuthenticated(UserModel.fromMap(userData, response.user!.email ?? '')));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _supabaseClient.auth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
