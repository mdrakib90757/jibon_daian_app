

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_Bachan_app/features/donate_blood/data/model/donate_blood_model.dart';

import 'donate_blood_event.dart';
import 'donate_blood_state.dart';

class DonateBloodBloc extends Bloc<DonateBloodEvent, DonateBloodState> {
  DonateBloodBloc() : super(const DonateBloodInitial()) {
    on<DonateBloodLoaded>(_onLoaded);
    on<DonateBloodSearchChanged>(_onSearchChanged);
    on<DonateBloodRegisterTapped>(_onRegisterTapped);
    on<DonateBloodSeeMapTapped>(_onSeeMapTapped);
  }

  Future<void> _onLoaded(
    DonateBloodLoaded event,
    Emitter<DonateBloodState> emit,
  ) async {
    emit(const DonateBloodLoading());
    await Future.delayed(const Duration(milliseconds: 400));
    emit(
      DonateBloodLoadedState(
        donorInfo: DonateDonorInfoModel.mock,
        allCenters: DonationCenterModel.mockList,
        filteredCenters: DonationCenterModel.mockList,
      ),
    );
  }

  void _onSearchChanged(
    DonateBloodSearchChanged event,
    Emitter<DonateBloodState> emit,
  ) {
    final current = _current;
    if (current == null) return;

    final q = event.query.toLowerCase();
    final filtered = q.isEmpty
        ? current.allCenters
        : current.allCenters
              .where((c) => c.name.toLowerCase().contains(q))
              .toList();

    emit(current.copyWith(filteredCenters: filtered, searchQuery: event.query));
  }

  Future<void> _onRegisterTapped(
    DonateBloodRegisterTapped event,
    Emitter<DonateBloodState> emit,
  ) async {
    emit(const DonateBloodRegisterSuccess());
    // Re-emit loaded
    await Future.delayed(const Duration(milliseconds: 100));
    emit(
      DonateBloodLoadedState(
        donorInfo: DonateDonorInfoModel.mock,
        allCenters: DonationCenterModel.mockList,
        filteredCenters: DonationCenterModel.mockList,
      ),
    );
  }

  void _onSeeMapTapped(
    DonateBloodSeeMapTapped event,
    Emitter<DonateBloodState> emit,
  ) {
    // TODO: Navigate to map
  }

  DonateBloodLoadedState? get _current {
    final s = state;
    return s is DonateBloodLoadedState ? s : null;
  }
}
