import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/user_profile/data/model/user_profile_model.dart';

import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(const EditProfileInitial()) {
    on<EditProfileLoaded>(_onLoaded);
    on<EditProfileNameChanged>(_onNameChanged);
    on<EditProfileEmailChanged>(_onEmailChanged);
    on<EditProfilePhoneChanged>(_onPhoneChanged);
    on<EditProfileLocationChanged>(_onLocationChanged);
    on<EditProfileBloodGroupChanged>(_onBloodGroupChanged);
    on<EditProfilePhotoChanged>(_onPhotoChanged);
    on<EditProfileSaveSubmitted>(_onSaveSubmitted);
  }

  Future<void> _onLoaded(
    EditProfileLoaded event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(const EditProfileLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    // Load from mock — replace with real API
    final p = UserProfileModel.mock;
    emit(
      EditProfileFormState(
        fullName: p.fullName,
        email: p.email,
        phone: p.phoneNumber,
        location: p.location,
        bloodGroup: p.bloodGroup,
      ),
    );
  }

  void _onNameChanged(
    EditProfileNameChanged e,
    Emitter<EditProfileState> emit,
  ) {
    _updateForm(emit, (s) => s.copyWith(fullName: e.name));
  }

  void _onEmailChanged(
    EditProfileEmailChanged e,
    Emitter<EditProfileState> emit,
  ) {
    _updateForm(emit, (s) => s.copyWith(email: e.email));
  }

  void _onPhoneChanged(
    EditProfilePhoneChanged e,
    Emitter<EditProfileState> emit,
  ) {
    _updateForm(emit, (s) => s.copyWith(phone: e.phone));
  }

  void _onLocationChanged(
    EditProfileLocationChanged e,
    Emitter<EditProfileState> emit,
  ) {
    _updateForm(emit, (s) => s.copyWith(location: e.location));
  }

  void _onBloodGroupChanged(
    EditProfileBloodGroupChanged e,
    Emitter<EditProfileState> emit,
  ) {
    _updateForm(emit, (s) => s.copyWith(bloodGroup: e.bloodGroup));
  }

  void _onPhotoChanged(
    EditProfilePhotoChanged e,
    Emitter<EditProfileState> emit,
  ) {
    _updateForm(emit, (s) => s.copyWith(photoPath: e.photoPath));
  }

  Future<void> _onSaveSubmitted(
    EditProfileSaveSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    final current = _currentForm;
    if (current == null) return;
    emit(current.copyWith(isSaving: true));
    await Future.delayed(const Duration(milliseconds: 1200));
    // TODO: real API call
    emit(const EditProfileSaveSuccess());
  }

  void _updateForm(
    Emitter<EditProfileState> emit,
    EditProfileFormState Function(EditProfileFormState) update,
  ) {
    final current = _currentForm;
    if (current != null) emit(update(current));
  }

  EditProfileFormState? get _currentForm {
    final s = state;
    return s is EditProfileFormState ? s : null;
  }
}
