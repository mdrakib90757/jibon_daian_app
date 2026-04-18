import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
    on<AuthChangePasswordSubmitted>(_onChangePassword);
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
        final String userId = response['data']['_id'];
        await TokenRepository().saveToken(token);
        final savedToken = await TokenRepository().getToken();
        final String userType = response['data']['type'];
        print("✅ Login Successful!");
        print("---------- USER ID: $userId ----------");
        print("---------- SAVED TOKEN: $savedToken ----------");
        debugPrint("👤 USER TYPE: ${userType.toUpperCase()}");
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

  Future<void> _onChangePassword(
    AuthChangePasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final response = await _repository.changePassword(
        userId: event.userId,
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );

      if (response['success'] == true) {
        emit(
          AuthChangePasswordSuccess(
            message: response['message'] ?? "Password changed!",
          ),
        );
      } else {
        emit(
          AuthFailure(
            message: response['message'] ?? "Failed to change password",
          ),
        );
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
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
