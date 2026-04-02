import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileLoading extends EditProfileState {
  const EditProfileLoading();
}

class EditProfileFormState extends EditProfileState {
  const EditProfileFormState({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.bloodGroup,
    this.photoPath,
    this.isSaving = false,
  });

  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String bloodGroup;
  final String? photoPath;
  final bool isSaving;

  EditProfileFormState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? bloodGroup,
    String? photoPath,
    bool? isSaving,
  }) {
    return EditProfileFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      photoPath: photoPath ?? this.photoPath,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    location,
    bloodGroup,
    photoPath,
    isSaving,
  ];
}

class EditProfileSaveSuccess extends EditProfileState {
  const EditProfileSaveSuccess();
}

class EditProfileSaveFailure extends EditProfileState {
  const EditProfileSaveFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
