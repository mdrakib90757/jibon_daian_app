import 'package:flutter_bloc/flutter_bloc.dart';

import '../../donate_blood/data/model/donate_blood_model.dart';
import '../../eligibility/data/model/eligibility_model.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(const AppointmentInitial()) {
    on<AppointmentLoaded>(_onLoaded);
    on<AppointmentCenterSelected>(_onCenterSelected);
    on<AppointmentDateSelected>(_onDateSelected);
    on<AppointmentTimeSelected>(_onTimeSelected);
    on<AppointmentConfirmed>(_onConfirmed);
  }

  void _onLoaded(AppointmentLoaded event, Emitter<AppointmentState> emit) {
    emit(
      AppointmentFormState(
        centers: DonationCenterModel.mockList,
        timeSlots: AppointmentSlot.mockSlots,
      ),
    );
  }

  void _onCenterSelected(
    AppointmentCenterSelected event,
    Emitter<AppointmentState> emit,
  ) {
    final current = _current;
    if (current == null) return;
    emit(
      current.copyWith(
        selectedCenterId: event.centerId,
        selectedCenterName: event.centerName,
      ),
    );
  }

  void _onDateSelected(
    AppointmentDateSelected event,
    Emitter<AppointmentState> emit,
  ) {
    final current = _current;
    if (current == null) return;
    emit(current.copyWith(selectedDate: event.date));
  }

  void _onTimeSelected(
    AppointmentTimeSelected event,
    Emitter<AppointmentState> emit,
  ) {
    final current = _current;
    if (current == null) return;
    emit(current.copyWith(selectedTime: event.time));
  }

  Future<void> _onConfirmed(
    AppointmentConfirmed event,
    Emitter<AppointmentState> emit,
  ) async {
    final current = _current;
    if (current == null || !current.isValid) return;

    emit(current.copyWith(isBooking: true));
    await Future.delayed(const Duration(milliseconds: 1200));
    // TODO: Replace with real API call
    // POST /appointments

    final dateStr =
        '${current.selectedDate!.day}/${current.selectedDate!.month}/${current.selectedDate!.year}';

    emit(
      AppointmentBooked(
        appointmentId: 'APT-${DateTime.now().millisecondsSinceEpoch}',
        centerName: current.selectedCenterName ?? '',
        date: dateStr,
        time: current.selectedTime ?? '',
        qrCode: 'JIBON-Bachan-APT-${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  AppointmentFormState? get _current {
    final s = state;
    return s is AppointmentFormState ? s : null;
  }
}
