part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

/// Triggered when splash screen is initialized
class SplashStarted extends SplashEvent {
  const SplashStarted();
}

/// Triggered on each timer tick to update progress
class SplashProgressUpdated extends SplashEvent {
  const SplashProgressUpdated(this.progress);
  final double progress;

  @override
  List<Object> get props => [progress];
}

/// Triggered when loading is complete
class SplashCompleted extends SplashEvent {
  const SplashCompleted();
}
