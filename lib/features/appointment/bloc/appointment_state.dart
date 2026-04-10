import 'package:equatable/equatable.dart';

import '../../donate_blood/data/model/donate_blood_model.dart';
import '../../eligibility/data/model/eligibility_model.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();
  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

class AppointmentFormState extends AppointmentState {
  const AppointmentFormState({
    required this.centers,
    required this.timeSlots,
    this.selectedCenterId,
    this.selectedCenterName,
    this.selectedDate,
    this.selectedTime,
    this.isBooking = false,
  });

  final List<DonationCenterModel> centers;
  final List<AppointmentSlot> timeSlots;
  final String? selectedCenterId;
  final String? selectedCenterName;
  final DateTime? selectedDate;
  final String? selectedTime;
  final bool isBooking;

  bool get isValid =>
      selectedCenterId != null && selectedDate != null && selectedTime != null;

  AppointmentFormState copyWith({
    List<DonationCenterModel>? centers,
    List<AppointmentSlot>? timeSlots,
    String? selectedCenterId,
    String? selectedCenterName,
    DateTime? selectedDate,
    String? selectedTime,
    bool? isBooking,
  }) {
    return AppointmentFormState(
      centers: centers ?? this.centers,
      timeSlots: timeSlots ?? this.timeSlots,
      selectedCenterId: selectedCenterId ?? this.selectedCenterId,
      selectedCenterName: selectedCenterName ?? this.selectedCenterName,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isBooking: isBooking ?? this.isBooking,
    );
  }

  @override
  List<Object?> get props => [
    selectedCenterId,
    selectedDate,
    selectedTime,
    isBooking,
  ];
}

class AppointmentBooked extends AppointmentState {
  const AppointmentBooked({
    required this.appointmentId,
    required this.centerName,
    required this.date,
    required this.time,
    required this.qrCode,
  });

  final String appointmentId;
  final String centerName;
  final String date;
  final String time;
  final String qrCode; // QR data string

  @override
  List<Object?> get props => [appointmentId, centerName, date, time];
}

class AppointmentError extends AppointmentState {
  const AppointmentError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
