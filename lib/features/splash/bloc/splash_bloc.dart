import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

/// SplashBloc - Manages the splash screen loading animation and navigation
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
    on<SplashProgressUpdated>(_onProgressUpdated);
    on<SplashCompleted>(_onSplashCompleted);
  }

  Timer? _timer;
  double _currentProgress = 0.0;
  static const double _targetProgress = 1.0;
  static const double _step = 0.05;
  static const Duration _interval = Duration(milliseconds: 150);

  void _onSplashStarted(SplashStarted event, Emitter<SplashState> emit) {
    _currentProgress = 0.0;
    emit(const SplashLoading(0.0));

    _timer = Timer.periodic(_interval, (timer) {
      _currentProgress += _step;
      if (_currentProgress >= _targetProgress) {
        _currentProgress = _targetProgress;
        timer.cancel();
        add(const SplashProgressUpdated(_targetProgress));
        add(const SplashCompleted());
      } else {
        add(SplashProgressUpdated(_currentProgress));
      }
    });
  }

  void _onProgressUpdated(
      SplashProgressUpdated event, Emitter<SplashState> emit) {
    emit(SplashLoading(event.progress.clamp(0.0, 1.0)));
  }

  void _onSplashCompleted(SplashCompleted event, Emitter<SplashState> emit) {
    emit(const SplashNavigateToOnboarding());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
