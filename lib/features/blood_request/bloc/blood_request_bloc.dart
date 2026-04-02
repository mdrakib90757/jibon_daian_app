import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blood_request_event.dart';
import 'blood_request_state.dart';

class BloodRequestBloc extends Bloc<BloodRequestEvent, BloodRequestState> {
  BloodRequestBloc() : super(const BloodRequestFormState()) {
    on<BloodRequestGroupSelected>(_onGroupSelected);
    on<BloodRequestPatientNameChanged>(_onPatientNameChanged);
    on<BloodRequestHospitalChanged>(_onHospitalChanged);
    on<BloodRequestLocationChanged>(_onLocationChanged);
    on<BloodRequestDateSelected>(_onDateSelected);
    on<BloodRequestContactChanged>(_onContactChanged);
    on<BloodRequestAdditionalChanged>(_onAdditionalChanged);
    on<BloodRequestSubmitted>(_onSubmitted);
    on<BloodRequestReset>(_onReset);
  }

  void _onGroupSelected(
    BloodRequestGroupSelected event,
    Emitter<BloodRequestState> emit,
  ) {
    final current = _currentForm;
    if (current == null) return;
    emit(current.copyWith(selectedBloodGroup: event.bloodGroup));
  }

  void _onPatientNameChanged(
    BloodRequestPatientNameChanged event,
    Emitter<BloodRequestState> emit,
  ) {
    final current = _currentForm;
    if (current == null) return;
    emit(current.copyWith(patientName: event.name));
  }

  void _onHospitalChanged(
    BloodRequestHospitalChanged event,
    Emitter<BloodRequestState> emit,
  ) {
    final current = _currentForm;
    if (current == null) return;
    emit(current.copyWith(hospitalName: event.hospital));
  }

  void _onLocationChanged(
    BloodRequestLocationChanged event,
    Emitter<BloodRequestState> emit,
  ) {
    final current = _currentForm;
    if (current == null) return;
    emit(current.copyWith(location: event.location));
  }

  void _onDateSelected(
    BloodRequestDateSelected event,
    Emitter<BloodRequestState> emit,
  ) {
    final current = _currentForm;
    if (current == null) return;
    emit(current.copyWith(neededDate: event.date));
  }

  void _onContactChanged(
    BloodRequestContactChanged event,
    Emitter<BloodRequestState> emit,
  ) {
    final current = _currentForm;
    if (current == null) return;
    emit(current.copyWith(contactNumber: event.contact));
  }

  void _onAdditionalChanged(
    BloodRequestAdditionalChanged event,
    Emitter<BloodRequestState> emit,
  ) {
    final current = _currentForm;
    if (current == null) return;
    emit(current.copyWith(additionalRequirements: event.text));
  }

  Future<void> _onSubmitted(
    BloodRequestSubmitted event,
    Emitter<BloodRequestState> emit,
  ) async {
    final current = _currentForm;
    if (current == null) return;

    if (!current.isValid) {
      emit(current.copyWith(errorMessage: 'Please fill all required fields'));
      return;
    }

    emit(current.copyWith(isSubmitting: true));
    await Future.delayed(const Duration(milliseconds: 1500));
    // TODO: Replace with real API call
    emit(const BloodRequestSuccess());
  }

  void _onReset(BloodRequestReset event, Emitter<BloodRequestState> emit) {
    emit(const BloodRequestFormState());
  }

  BloodRequestFormState? get _currentForm {
    final s = state;
    return s is BloodRequestFormState ? s : null;
  }
}
