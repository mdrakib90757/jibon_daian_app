import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_support_event.dart';
import 'contact_support_state.dart';

class ContactSupportBloc
    extends Bloc<ContactSupportEvent, ContactSupportState> {
  ContactSupportBloc() : super(const ContactSupportInitial()) {
    on<ContactSubjectChanged>(_onSubjectChanged);
    on<ContactMessageChanged>(_onMessageChanged);
    on<ContactSendSubmitted>(_onSendSubmitted);
    on<ContactReset>(_onReset);
  }

  void _onSubjectChanged(
    ContactSubjectChanged event,
    Emitter<ContactSupportState> emit,
  ) {
    final c = _current;
    if (c != null) emit(c.copyWith(subject: event.subject));
  }

  void _onMessageChanged(
    ContactMessageChanged event,
    Emitter<ContactSupportState> emit,
  ) {
    final c = _current;
    if (c != null) emit(c.copyWith(message: event.message));
  }

  Future<void> _onSendSubmitted(
    ContactSendSubmitted event,
    Emitter<ContactSupportState> emit,
  ) async {
    final c = _current;
    if (c == null) return;
    if (c.subject.isEmpty || c.message.isEmpty) {
      emit(
        const ContactSupportFailure(message: 'Please fill subject and message'),
      );
      emit(c);
      return;
    }
    emit(c.copyWith(isSending: true));
    await Future.delayed(const Duration(milliseconds: 1200));
    emit(const ContactSupportSuccess());
  }

  void _onReset(ContactReset event, Emitter<ContactSupportState> emit) {
    emit(const ContactSupportInitial());
  }

  ContactSupportInitial? get _current {
    final s = state;
    return s is ContactSupportInitial ? s : null;
  }
}
