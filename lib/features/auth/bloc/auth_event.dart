import 'package:equatable/equatable.dart';
import 'package:jibon_Bachan_app/features/auth/data/model/register_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterSubmitted extends AuthEvent {
  const AuthRegisterSubmitted({required this.requestData});

  final RegisterRequest requestData;

  @override
  List<Object?> get props => [requestData];
}

class AuthChangePasswordSubmitted extends AuthEvent {
  final String userId;
  final String oldPassword;
  final String newPassword;

  const AuthChangePasswordSubmitted({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, oldPassword, newPassword];
}

class AuthPasswordVisibilityToggled extends AuthEvent {
  const AuthPasswordVisibilityToggled();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthResetStatus extends AuthEvent {
  const AuthResetStatus();
}
