import 'package:equatable/equatable.dart';

abstract class BloodRequestState extends Equatable {
  const BloodRequestState();

  @override
  List<Object?> get props => [];
}

/// Initial / form filling state
class BloodRequestFormState extends BloodRequestState {
  const BloodRequestFormState({
    this.patientName = '',
    this.selectedBloodGroup = '',
    this.hospitalName = '',
    this.location = '',
    this.neededDate = '',
    this.contactNumber = '',
    this.additionalRequirements = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String patientName;
  final String selectedBloodGroup;
  final String hospitalName;
  final String location;
  final String neededDate;
  final String contactNumber;
  final String additionalRequirements;
  final bool isSubmitting;
  final String? errorMessage;

  bool get isValid =>
      patientName.isNotEmpty &&
      selectedBloodGroup.isNotEmpty &&
      hospitalName.isNotEmpty &&
      location.isNotEmpty &&
      neededDate.isNotEmpty &&
      contactNumber.isNotEmpty;

  BloodRequestFormState copyWith({
    String? patientName,
    String? selectedBloodGroup,
    String? hospitalName,
    String? location,
    String? neededDate,
    String? contactNumber,
    String? additionalRequirements,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return BloodRequestFormState(
      patientName: patientName ?? this.patientName,
      selectedBloodGroup: selectedBloodGroup ?? this.selectedBloodGroup,
      hospitalName: hospitalName ?? this.hospitalName,
      location: location ?? this.location,
      neededDate: neededDate ?? this.neededDate,
      contactNumber: contactNumber ?? this.contactNumber,
      additionalRequirements:
          additionalRequirements ?? this.additionalRequirements,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    patientName,
    selectedBloodGroup,
    hospitalName,
    location,
    neededDate,
    contactNumber,
    additionalRequirements,
    isSubmitting,
    errorMessage,
  ];
}

/// Request posted successfully
class BloodRequestSuccess extends BloodRequestState {
  const BloodRequestSuccess();
}

/// Request failed
class BloodRequestFailure extends BloodRequestState {
  const BloodRequestFailure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
