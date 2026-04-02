import 'package:equatable/equatable.dart';

abstract class BloodRequestEvent extends Equatable {
  const BloodRequestEvent();

  @override
  List<Object?> get props => [];
}

/// Blood group chip selected
class BloodRequestGroupSelected extends BloodRequestEvent {
  const BloodRequestGroupSelected(this.bloodGroup);
  final String bloodGroup;

  @override
  List<Object?> get props => [bloodGroup];
}

/// Patient name changed
class BloodRequestPatientNameChanged extends BloodRequestEvent {
  const BloodRequestPatientNameChanged(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}

/// Hospital name changed
class BloodRequestHospitalChanged extends BloodRequestEvent {
  const BloodRequestHospitalChanged(this.hospital);
  final String hospital;

  @override
  List<Object?> get props => [hospital];
}

/// Location changed
class BloodRequestLocationChanged extends BloodRequestEvent {
  const BloodRequestLocationChanged(this.location);
  final String location;

  @override
  List<Object?> get props => [location];
}

/// Date selected
class BloodRequestDateSelected extends BloodRequestEvent {
  const BloodRequestDateSelected(this.date);
  final String date;

  @override
  List<Object?> get props => [date];
}

/// Contact number changed
class BloodRequestContactChanged extends BloodRequestEvent {
  const BloodRequestContactChanged(this.contact);
  final String contact;

  @override
  List<Object?> get props => [contact];
}

/// Additional requirements changed
class BloodRequestAdditionalChanged extends BloodRequestEvent {
  const BloodRequestAdditionalChanged(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

/// Form submitted
class BloodRequestSubmitted extends BloodRequestEvent {
  const BloodRequestSubmitted();
}

/// Form reset
class BloodRequestReset extends BloodRequestEvent {
  const BloodRequestReset();
}
