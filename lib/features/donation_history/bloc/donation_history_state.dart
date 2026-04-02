import 'package:equatable/equatable.dart';

import '../data/model/donation_history_model.dart';

abstract class DonationHistoryState extends Equatable {
  const DonationHistoryState();

  @override
  List<Object?> get props => [];
}

class DonationHistoryInitial extends DonationHistoryState {
  const DonationHistoryInitial();
}

class DonationHistoryLoading extends DonationHistoryState {
  const DonationHistoryLoading();
}

class DonationHistoryLoadedState extends DonationHistoryState {
  const DonationHistoryLoadedState({
    required this.donations,
    required this.totalDonations,
    required this.livesSaved,
    required this.badgeMessage,
  });

  final List<DonationHistoryModel> donations;
  final int totalDonations;
  final int livesSaved;
  final String badgeMessage;

  @override
  List<Object?> get props => [
    donations,
    totalDonations,
    livesSaved,
    badgeMessage,
  ];
}

class DonationHistoryError extends DonationHistoryState {
  const DonationHistoryError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
