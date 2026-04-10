import 'package:equatable/equatable.dart';

abstract class EligibilityEvent extends Equatable {
  const EligibilityEvent();
  @override
  List<Object?> get props => [];
}

class EligibilityLoaded extends EligibilityEvent {
  const EligibilityLoaded();
}

/// User answered a question
class EligibilityAnswered extends EligibilityEvent {
  const EligibilityAnswered({
    required this.questionId,
    required this.answer, // true = Yes, false = No
  });
  final String questionId;
  final bool answer;
  @override
  List<Object?> get props => [questionId, answer];
}

/// User submitted the form
class EligibilitySubmitted extends EligibilityEvent {
  const EligibilitySubmitted();
}
