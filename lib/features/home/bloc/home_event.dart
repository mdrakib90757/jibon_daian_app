part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeEvent {
  const HomeLoaded();
}

class HomeTabChanged extends HomeEvent {
  const HomeTabChanged(this.index);
  final int index;
  @override
  List<Object?> get props => [index];
}

class HomeSearchChanged extends HomeEvent {
  const HomeSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}
