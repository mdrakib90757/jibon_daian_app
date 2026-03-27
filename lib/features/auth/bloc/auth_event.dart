part of 'auth_bloc.dart';

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
  const AuthRegisterSubmitted({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.bloodGroup,
  });
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String bloodGroup;
  @override
  List<Object?> get props => [fullName, email, phone, location, bloodGroup];
}

class AuthForgotPasswordSubmitted extends AuthEvent {
  const AuthForgotPasswordSubmitted({required this.email});
  final String email;
  @override
  List<Object?> get props => [email];
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
