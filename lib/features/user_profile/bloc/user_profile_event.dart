import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load user profile data
class UserProfileLoaded extends UserProfileEvent {
  const UserProfileLoaded();
}

/// Edit profile tapped
class UserProfileEditTapped extends UserProfileEvent {
  const UserProfileEditTapped();
}

/// Logout tapped
class UserProfileLogoutTapped extends UserProfileEvent {
  const UserProfileLogoutTapped();
}

/// Change password tapped
class UserProfileChangePasswordTapped extends UserProfileEvent {
  const UserProfileChangePasswordTapped();
}

/// Notification settings tapped
class UserProfileNotificationsTapped extends UserProfileEvent {
  const UserProfileNotificationsTapped();
}

/// Privacy policy tapped
class UserProfilePrivacyTapped extends UserProfileEvent {
  const UserProfilePrivacyTapped();
}
