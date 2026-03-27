part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeDashState extends HomeState {
  const HomeDashState({
    required this.userName,
    required this.activeTab,
    this.searchQuery = '',
  });
  final String userName;
  final int activeTab;
  final String searchQuery;

  HomeDashState copyWith({
    String? userName,
    int? activeTab,
    String? searchQuery,
  }) {
    return HomeDashState(
      userName: userName ?? this.userName,
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [userName, activeTab, searchQuery];
}

class HomeFailure extends HomeState {
  const HomeFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
