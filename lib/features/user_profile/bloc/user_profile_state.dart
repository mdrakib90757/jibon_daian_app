import 'package:equatable/equatable.dart';
import 'package:jibon_Bachan_app/features/user_profile/data/model/user_profile_model.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

/// Loading state
class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

/// Profile loaded successfully
class UserProfileLoadedState extends UserProfileState {
  const UserProfileLoadedState({required this.profile});
  final UserProfileModel profile;

  @override
  List<Object?> get props => [profile];
}

/// Navigate to edit profile
class UserProfileNavigateEdit extends UserProfileState {
  const UserProfileNavigateEdit();
}

/// Navigate to login (after logout)
class UserProfileNavigateLogin extends UserProfileState {
  const UserProfileNavigateLogin();
}

/// Error state
class UserProfileError extends UserProfileState {
  const UserProfileError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
