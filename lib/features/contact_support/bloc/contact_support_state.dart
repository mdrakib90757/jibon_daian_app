import 'package:equatable/equatable.dart';

abstract class ContactSupportState extends Equatable {
  const ContactSupportState();
  @override
  List<Object?> get props => [];
}

class ContactSupportInitial extends ContactSupportState {
  const ContactSupportInitial({
    this.subject = '',
    this.message = '',
    this.isSending = false,
  });

  final String subject;
  final String message;
  final bool isSending;

  ContactSupportInitial copyWith({
    String? subject,
    String? message,
    bool? isSending,
  }) {
    return ContactSupportInitial(
      subject: subject ?? this.subject,
      message: message ?? this.message,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [subject, message, isSending];
}

class ContactSupportSuccess extends ContactSupportState {
  const ContactSupportSuccess();
}

class ContactSupportFailure extends ContactSupportState {
  const ContactSupportFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
