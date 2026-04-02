import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/hospital_model.dart';
import 'hospital_event.dart';
import 'hospital_state.dart';

class HospitalBloc extends Bloc<HospitalEvent, HospitalState> {
  HospitalBloc() : super(const HospitalInitial()) {
    on<HospitalLoaded>(_onLoaded);
    on<HospitalSearchChanged>(_onSearchChanged);
    on<HospitalViewToggled>(_onViewToggled);
  }

  Future<void> _onLoaded(
    HospitalLoaded event,
    Emitter<HospitalState> emit,
  ) async {
    emit(const HospitalLoading());
    await Future.delayed(const Duration(milliseconds: 400));

    const hospitals = HospitalModel.mockList;
    final urgent = hospitals.where((h) => h.hasUrgentNeed).toList();

    emit(
      HospitalLoadedState(
        hospitals: hospitals,
        filteredHospitals: hospitals,
        urgentCount: urgent.length,
        urgentBloodGroup: urgent.isNotEmpty
            ? urgent.first.urgentBloodGroup ?? 'O+'
            : 'O+',
        isListView: true,
      ),
    );
  }

  void _onSearchChanged(
    HospitalSearchChanged event,
    Emitter<HospitalState> emit,
  ) {
    final current = _current;
    if (current == null) return;

    final q = event.query.toLowerCase();
    final filtered = q.isEmpty
        ? current.hospitals
        : current.hospitals
              .where(
                (h) =>
                    h.name.toLowerCase().contains(q) ||
                    h.location.toLowerCase().contains(q),
              )
              .toList();

    emit(
      current.copyWith(filteredHospitals: filtered, searchQuery: event.query),
    );
  }

  void _onViewToggled(HospitalViewToggled event, Emitter<HospitalState> emit) {
    final current = _current;
    if (current == null) return;
    emit(current.copyWith(isListView: event.isListView));
  }

  HospitalLoadedState? get _current {
    final s = state;
    return s is HospitalLoadedState ? s : null;
  }
}
