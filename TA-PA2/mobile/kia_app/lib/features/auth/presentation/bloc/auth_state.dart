import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Loading
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Success Login
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

// Logout / Belum Login
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// Error
class AuthError extends AuthState {

  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}