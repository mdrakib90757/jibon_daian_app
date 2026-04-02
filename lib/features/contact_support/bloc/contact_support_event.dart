import 'package:equatable/equatable.dart';

abstract class ContactSupportEvent extends Equatable {
  const ContactSupportEvent();
  @override
  List<Object?> get props => [];
}

class ContactSubjectChanged extends ContactSupportEvent {
  const ContactSubjectChanged(this.subject);
  final String subject;
  @override
  List<Object?> get props => [subject];
}

class ContactMessageChanged extends ContactSupportEvent {
  const ContactMessageChanged(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ContactSendSubmitted extends ContactSupportEvent {
  const ContactSendSubmitted();
}

class ContactReset extends ContactSupportEvent {
  const ContactReset();
}
