import 'package:equatable/equatable.dart';
import 'package:jibon_daian_app/features/eligibility/data/model/eligibility_model.dart';

abstract class EligibilityState extends Equatable {
  const EligibilityState();
  @override
  List<Object?> get props => [];
}

class EligibilityInitial extends EligibilityState {
  const EligibilityInitial();
}

class EligibilityFormState extends EligibilityState {
  const EligibilityFormState({
    required this.questions,
    required this.answers,
    this.isChecking = false,
  });

  final List<EligibilityQuestion> questions;
  final Map<String, bool> answers; // questionId → answer
  final bool isChecking;

  // How many questions answered
  int get answeredCount => answers.length;
  bool get allAnswered => answers.length == questions.length;

  // Check if all answers match passAnswer
  bool get isEligible => questions.every((q) => answers[q.id] == q.passAnswer);

  // Find first failed question
  EligibilityQuestion? get firstFailedQuestion => questions.firstWhere(
    (q) => answers[q.id] != null && answers[q.id] != q.passAnswer,
    orElse: () => questions.first,
  );

  EligibilityFormState copyWith({
    List<EligibilityQuestion>? questions,
    Map<String, bool>? answers,
    bool? isChecking,
  }) {
    return EligibilityFormState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      isChecking: isChecking ?? this.isChecking,
    );
  }

  @override
  List<Object?> get props => [questions, answers, isChecking];
}

/// User passed eligibility
class EligibilityPassed extends EligibilityState {
  const EligibilityPassed();
}

/// User failed eligibility
class EligibilityFailed extends EligibilityState {
  const EligibilityFailed({required this.reason});
  final String reason;
  @override
  List<Object?> get props => [reason];
}
