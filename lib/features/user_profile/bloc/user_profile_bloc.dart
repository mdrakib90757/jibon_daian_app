import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/user_profile/bloc/user_profile_event.dart';
import 'package:jibon_daian_app/features/user_profile/bloc/user_profile_state.dart';
import '../data/model/user_profile_model.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(const UserProfileInitial()) {
    on<UserProfileLoaded>(_onLoaded);
    on<UserProfileEditTapped>(_onEditTapped);
    on<UserProfileLogoutTapped>(_onLogoutTapped);
    on<UserProfileChangePasswordTapped>(_onChangePassword);
    on<UserProfileNotificationsTapped>(_onNotifications);
    on<UserProfilePrivacyTapped>(_onPrivacy);
  }

  Future<void> _onLoaded(
    UserProfileLoaded event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(const UserProfileLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Replace with real API call
    emit(const UserProfileLoadedState(profile: UserProfileModel.mock));
  }

  void _onEditTapped(
    UserProfileEditTapped event,
    Emitter<UserProfileState> emit,
  ) {
    emit(const UserProfileNavigateEdit());
    // Re-emit loaded state so screen doesn't break
    emit(const UserProfileLoadedState(profile: UserProfileModel.mock));
  }

  Future<void> _onLogoutTapped(
    UserProfileLogoutTapped event,
    Emitter<UserProfileState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    emit(const UserProfileNavigateLogin());
  }

  void _onChangePassword(
    UserProfileChangePasswordTapped event,
    Emitter<UserProfileState> emit,
  ) {
    // TODO: Navigate to change password
  }

  void _onNotifications(
    UserProfileNotificationsTapped event,
    Emitter<UserProfileState> emit,
  ) {
    // TODO: Navigate to notification settings
  }

  void _onPrivacy(
    UserProfilePrivacyTapped event,
    Emitter<UserProfileState> emit,
  ) {
    // TODO: Navigate to privacy policy
  }
}
