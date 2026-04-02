import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthRegisterSubmitted>(_onRegister);
    on<AuthForgotPasswordSubmitted>(_onForgotPassword);
    on<AuthPasswordVisibilityToggled>(_onTogglePassword);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthResetStatus>(_onReset);
  }

  bool _isPasswordVisible = false;

  Future<void> _onLogin(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 1500));
    // TODO: Replace with real API call
    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      emit(const AuthLoginSuccess());
    } else {
      emit(const AuthFailure(message: 'Invalid email or password.'));
    }
  }

  Future<void> _onRegister(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 1500));
    // TODO: Replace with real API call
    emit(const AuthRegisterSuccess());
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
