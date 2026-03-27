import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

/// OnboardingBloc - Manages page navigation through onboarding slides
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final int _totalPages;

  OnboardingBloc({required int totalPages})
    : _totalPages = totalPages,
      super(OnboardingPageState(currentPage: 0, totalPages: totalPages)) {
    on<OnboardingNextPage>(_onNextPage);
    on<OnboardingPreviousPage>(_onPreviousPage);
    on<OnboardingSkipped>(_onSkipped);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingGetStarted>(_onGetStarted);
  }

  void _onNextPage(OnboardingNextPage event, Emitter<OnboardingState> emit) {
    final current = _currentPage;
    if (current < _totalPages - 1) {
      emit(
        OnboardingPageState(currentPage: current + 1, totalPages: _totalPages),
      );
    } else {
      emit(const OnboardingComplete());
    }
  }

  void _onPreviousPage(
    OnboardingPreviousPage event,
    Emitter<OnboardingState> emit,
  ) {
    final current = _currentPage;
    if (current > 0) {
      emit(
        OnboardingPageState(currentPage: current - 1, totalPages: _totalPages),
      );
    }
  }

  void _onSkipped(OnboardingSkipped event, Emitter<OnboardingState> emit) {
    emit(const OnboardingComplete());
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      OnboardingPageState(
        currentPage: event.pageIndex,
        totalPages: _totalPages,
      ),
    );
  }

  void _onGetStarted(
    OnboardingGetStarted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(const OnboardingComplete());
  }

  int get _currentPage {
    final s = state;
    return s is OnboardingPageState ? s.currentPage : 0;
  }
}
