import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String university;
  final String password;

  const AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.university,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, university, password];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String email;
  final String token;

  const AuthVerifyOtpRequested({
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [email, token];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthProfileUpdated extends AuthEvent {
  final String fullName;
  final String university;

  const AuthProfileUpdated({
    required this.fullName,
    required this.university,
  });

  @override
  List<Object?> get props => [fullName, university];
}

