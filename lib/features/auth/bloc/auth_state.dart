

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial({this.isPasswordVisible = false});
  final bool isPasswordVisible;
  @override
  List<Object?> get props => [isPasswordVisible];
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess();
}

class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess();
}

class AuthForgotPasswordSuccess extends AuthState {
  const AuthForgotPasswordSuccess();
}

class AuthFailure extends AuthState {
  const AuthFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class AuthPasswordVisibilityChanged extends AuthState {
  const AuthPasswordVisibilityChanged({required this.isVisible});
  final bool isVisible;
  @override
  List<Object?> get props => [isVisible];
}
