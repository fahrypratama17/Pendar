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
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
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
      emit(AuthFailure(_getErrorMessage(e)));
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
        emit(AuthNeedsVerification(
          email: event.email,
          message: 'Pendaftaran berhasil! Silakan konfirmasi email Anda.',
        ));
        return;
      }
      final userData = await _supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      emit(AuthAuthenticated(UserModel.fromMap(userData, response.user!.email ?? '')));
    } catch (e) {
      emit(AuthFailure(_getErrorMessage(e)));
    }
  }

  Future<void> _onVerifyOtpRequested(AuthVerifyOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _supabaseClient.auth.verifyOTP(
        email: event.email,
        token: event.token,
        type: OtpType.signup,
      );
      if (response.user == null) {
        emit(const AuthFailure('Verification failed: User not found'));
        return;
      }
      final userData = await _supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      emit(AuthAuthenticated(UserModel.fromMap(userData, response.user!.email ?? '')));
    } catch (e) {
      emit(AuthFailure(_getErrorMessage(e)));
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _supabaseClient.auth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(_getErrorMessage(e)));
    }
  }

  String _getErrorMessage(dynamic e) {
    if (e is AuthException) {
      switch (e.code) {
        case 'otp_expired':
          return 'Kode verifikasi telah kedaluwarsa. Silakan kirim kode baru.';
        case 'invalid_credentials':
          return 'Email atau password salah.';
        case 'email_not_confirmed':
          return 'Email Anda belum dikonfirmasi. Silakan konfirmasi email Anda.';
        case 'user_already_exists':
          return 'Email sudah terdaftar. Silakan gunakan email lain atau masuk.';
        default:
          return e.message;
      }
    }
    return e.toString();
  }
}
