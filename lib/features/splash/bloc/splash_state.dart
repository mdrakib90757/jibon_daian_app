part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

/// Initial state before splash starts
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Loading state with a progress value from 0.0 to 1.0
class SplashLoading extends SplashState {
  const SplashLoading(this.progress);
  final double progress;

  @override
  List<Object> get props => [progress];
}

/// Navigation trigger state: go to onboarding
class SplashNavigateToOnboarding extends SplashState {
  const SplashNavigateToOnboarding();
}
