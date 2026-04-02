import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class EditProfileLoaded extends EditProfileEvent {
  const EditProfileLoaded();
}

class EditProfileNameChanged extends EditProfileEvent {
  const EditProfileNameChanged(this.name);
  final String name;
  @override
  List<Object?> get props => [name];
}

class EditProfileEmailChanged extends EditProfileEvent {
  const EditProfileEmailChanged(this.email);
  final String email;
  @override
  List<Object?> get props => [email];
}

class EditProfilePhoneChanged extends EditProfileEvent {
  const EditProfilePhoneChanged(this.phone);
  final String phone;
  @override
  List<Object?> get props => [phone];
}

class EditProfileLocationChanged extends EditProfileEvent {
  const EditProfileLocationChanged(this.location);
  final String location;
  @override
  List<Object?> get props => [location];
}

class EditProfileBloodGroupChanged extends EditProfileEvent {
  const EditProfileBloodGroupChanged(this.bloodGroup);
  final String bloodGroup;
  @override
  List<Object?> get props => [bloodGroup];
}

class EditProfilePhotoChanged extends EditProfileEvent {
  const EditProfilePhotoChanged(this.photoPath);
  final String photoPath;
  @override
  List<Object?> get props => [photoPath];
}

class EditProfileSaveSubmitted extends EditProfileEvent {
  const EditProfileSaveSubmitted();
}
