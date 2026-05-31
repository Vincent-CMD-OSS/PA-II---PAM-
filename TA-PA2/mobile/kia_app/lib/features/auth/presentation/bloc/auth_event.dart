import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Login
class AuthLoginRequested extends AuthEvent {

  final String identifier;
  final String password;

  const AuthLoginRequested({
    required this.identifier,
    required this.password,
  });

  @override
  List<Object?> get props => [
        identifier,
        password,
      ];
}

// Logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

// Check Session
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}