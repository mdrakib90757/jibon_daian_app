import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/eligibility_model.dart';
import 'eligibility_event.dart';
import 'eligibility_state.dart';

class EligibilityBloc extends Bloc<EligibilityEvent, EligibilityState> {
  EligibilityBloc() : super(const EligibilityInitial()) {
    on<EligibilityLoaded>(_onLoaded);
    on<EligibilityAnswered>(_onAnswered);
    on<EligibilitySubmitted>(_onSubmitted);
  }

  void _onLoaded(EligibilityLoaded event, Emitter<EligibilityState> emit) {
    emit(
      EligibilityFormState(
        questions: EligibilityQuestion.questions,
        answers: const {},
      ),
    );
  }

  void _onAnswered(EligibilityAnswered event, Emitter<EligibilityState> emit) {
    final current = _current;
    if (current == null) return;

    final updatedAnswers = Map<String, bool>.from(current.answers);
    updatedAnswers[event.questionId] = event.answer;

    emit(current.copyWith(answers: updatedAnswers));
  }

  Future<void> _onSubmitted(
    EligibilitySubmitted event,
    Emitter<EligibilityState> emit,
  ) async {
    final current = _current;
    if (current == null) return;

    emit(current.copyWith(isChecking: true));
    await Future.delayed(const Duration(milliseconds: 800));

    if (current.isEligible) {
      emit(const EligibilityPassed());
    } else {
      final failed = current.firstFailedQuestion;
      emit(
        EligibilityFailed(
          reason:
              'You are not eligible to donate at this time.\n'
              'Reason: ${failed?.question ?? "Health criteria not met"}',
        ),
      );
    }
  }

  EligibilityFormState? get _current {
    final s = state;
    return s is EligibilityFormState ? s : null;
  }
}
