import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();
  @override
  List<Object?> get props => [];
}

class AppointmentLoaded extends AppointmentEvent {
  const AppointmentLoaded();
}

class AppointmentCenterSelected extends AppointmentEvent {
  const AppointmentCenterSelected(this.centerId, this.centerName);
  final String centerId;
  final String centerName;
  @override
  List<Object?> get props => [centerId, centerName];
}

class AppointmentDateSelected extends AppointmentEvent {
  const AppointmentDateSelected(this.date);
  final DateTime date;
  @override
  List<Object?> get props => [date];
}

class AppointmentTimeSelected extends AppointmentEvent {
  const AppointmentTimeSelected(this.time);
  final String time;
  @override
  List<Object?> get props => [time];
}

class AppointmentConfirmed extends AppointmentEvent {
  const AppointmentConfirmed();
}
