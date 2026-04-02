import 'package:equatable/equatable.dart';

abstract class DonationHistoryEvent extends Equatable {
  const DonationHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load donation history
class DonationHistoryLoaded extends DonationHistoryEvent {
  const DonationHistoryLoaded();
}
