import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_Bachan_app/core/data/repository/token_repository.dart';
import 'package:jibon_Bachan_app/features/auth/data/repository/auth_api.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository = AuthRepository();
  bool _isPasswordVisible = false;

  AuthBloc() : super(const AuthInitial()) {
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthRegisterSubmitted>(_onRegister);
    on<AuthForgotPasswordSubmitted>(_onForgotPassword);
    on<AuthPasswordVisibilityToggled>(_onTogglePassword);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthResetStatus>(_onReset);
  }

  Future<void> _onLogin(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final response = await _repository.login(event.email, event.password);
      if (response['success'] == true) {
        final token = response['token'];
        await TokenRepository().saveToken(token);
        final savedToken = await TokenRepository().getToken();
        print("---------- SAVED TOKEN: $savedToken ----------");
        emit(const AuthLoginSuccess());
      } else {
        emit(AuthFailure(message: response['message'] ?? "Login Failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onRegister(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final response = await _repository.register(event.requestData);
      if (response['success'] == true) {
        emit(const AuthRegisterSuccess());
      } else {
        emit(
          AuthFailure(message: response['message'] ?? "Registration Failed"),
        );
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onForgotPassword(
    AuthForgotPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 1500));
    // TODO: Replace with real API call
    emit(const AuthForgotPasswordSuccess());
  }

  void _onTogglePassword(
    AuthPasswordVisibilityToggled event,
    Emitter<AuthState> emit,
  ) {
    _isPasswordVisible = !_isPasswordVisible;
    emit(AuthPasswordVisibilityChanged(isVisible: _isPasswordVisible));
  }

  void _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }

  void _onReset(AuthResetStatus event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }
}
