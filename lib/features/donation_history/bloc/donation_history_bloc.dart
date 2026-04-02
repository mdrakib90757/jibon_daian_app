import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/donation_history_model.dart';
import 'donation_history_event.dart';
import 'donation_history_state.dart';

class DonationHistoryBloc
    extends Bloc<DonationHistoryEvent, DonationHistoryState> {
  DonationHistoryBloc() : super(const DonationHistoryInitial()) {
    on<DonationHistoryLoaded>(_onLoaded);
  }

  Future<void> _onLoaded(
    DonationHistoryLoaded event,
    Emitter<DonationHistoryState> emit,
  ) async {
    emit(const DonationHistoryLoading());
    await Future.delayed(const Duration(milliseconds: 500));

    const donations = DonationHistoryModel.mockList;
    final total = donations.length;
    final lives = total * 3; // 1 donation = 3 lives saved

    emit(
      DonationHistoryLoadedState(
        donations: donations,
        totalDonations: total,
        livesSaved: lives,
        badgeMessage:
            'Great Job!\nYou are 2 donations away from your Silver Badge 🏅',
      ),
    );
  }
}
