import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';

import 'package:ta_pa2_pa3_project/features/auth/data/datasources/auth_api_services.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthApiService _authApiService;

  AuthBloc({
    AuthApiService? authApiService,
  }) : _authApiService =
            authApiService ??
            AuthApiService(),

       super(const AuthInitial()) {

    on<AuthLoginRequested>(
      _onLoginRequested,
    );

    on<AuthLogoutRequested>(
      _onLogoutRequested,
    );

    on<AuthCheckRequested>(
      _onCheckRequested,
    );
  }

  // Login
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {

    emit(const AuthLoading());

    try {

      final identifier =
          event.identifier.trim();

      final password =
          event.password.trim();

      // Validasi identifier
      if (identifier.isEmpty) {

        emit(
          const AuthError(
            'Username atau email wajib diisi.',
          ),
        );

        return;
      }

      // Validasi password
      if (password.isEmpty) {

        emit(
          const AuthError(
            'Password wajib diisi.',
          ),
        );

        return;
      }

      await _authApiService.login(

        identifier: identifier,

        password: password,
      );

      emit(
        const AuthAuthenticated(),
      );

    } catch (e) {

      emit(
        AuthError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  // Logout
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {

    try {

      await _authApiService.logout();

      emit(
        const AuthUnauthenticated(),
      );

    } catch (e) {

      emit(
        AuthError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  // Check session
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {

    try {

      await AuthSession.initialize();

      if (AuthSession.isLoggedIn &&
          AuthSession.isSessionValid) {

        emit(
          const AuthAuthenticated(),
        );

      } else {

        await AuthSession.clear();

        emit(
          const AuthUnauthenticated(),
        );
      }

    } catch (e) {

      emit(
        AuthError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {

    _authApiService.dispose();

    return super.close();
  }
}