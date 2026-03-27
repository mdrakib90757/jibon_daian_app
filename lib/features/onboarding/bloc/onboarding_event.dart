part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

/// Move to the next onboarding page
class OnboardingNextPage extends OnboardingEvent {
  const OnboardingNextPage();
}

/// Move to previous onboarding page
class OnboardingPreviousPage extends OnboardingEvent {
  const OnboardingPreviousPage();
}

/// Skip all onboarding
class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}

/// Page changed via swipe
class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.pageIndex);
  final int pageIndex;

  @override
  List<Object> get props => [pageIndex];
}

/// Get started tapped on last slide
class OnboardingGetStarted extends OnboardingEvent {
  const OnboardingGetStarted();
}
