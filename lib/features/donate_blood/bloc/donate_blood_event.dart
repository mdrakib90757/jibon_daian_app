import 'package:equatable/equatable.dart';

abstract class DonateBloodEvent extends Equatable {
  const DonateBloodEvent();
  @override
  List<Object?> get props => [];
}

/// Screen load
class DonateBloodLoaded extends DonateBloodEvent {
  const DonateBloodLoaded();
}

/// Search centers
class DonateBloodSearchChanged extends DonateBloodEvent {
  const DonateBloodSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

/// Register to donate tapped
class DonateBloodRegisterTapped extends DonateBloodEvent {
  const DonateBloodRegisterTapped();
}

/// See map tapped
class DonateBloodSeeMapTapped extends DonateBloodEvent {
  const DonateBloodSeeMapTapped();
}
