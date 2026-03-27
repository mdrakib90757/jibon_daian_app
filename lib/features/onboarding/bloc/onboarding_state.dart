part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

/// Initial / default onboarding state
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

/// Active state - user is viewing a specific page
class OnboardingPageState extends OnboardingState {
  const OnboardingPageState({
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  bool get isLastPage => currentPage == totalPages - 1;
  bool get isFirstPage => currentPage == 0;

  @override
  List<Object> get props => [currentPage, totalPages];
}

/// Navigate to main app / home
class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}
