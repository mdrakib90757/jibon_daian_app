import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeLoaded>(_onLoaded);
    on<HomeTabChanged>(_onTabChanged);
    on<HomeSearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoaded(HomeLoaded event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const HomeDashState(userName: 'Jibon Bachan', activeTab: 0));
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    final current = state;
    if (current is HomeDashState) {
      emit(current.copyWith(activeTab: event.index));
    }
  }

  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    final current = state;
    if (current is HomeDashState) {
      emit(current.copyWith(searchQuery: event.query));
    }
  }
}
