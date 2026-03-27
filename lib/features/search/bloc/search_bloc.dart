import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/search/bloc/search_event.dart';
import 'package:jibon_daian_app/features/search/bloc/search_state.dart';
import '../data/model.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchInitial()) {
    on<SearchInitialized>(_onInitialized);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchBloodGroupToggled>(_onBloodGroupToggled);
    on<SearchCityToggled>(_onCityToggled);
    on<SearchAvailabilityToggled>(_onAvailabilityToggled);
    on<SearchSortChanged>(_onSortChanged);
    on<SearchFiltersCleared>(_onFiltersCleared);
  }

  // ── Initial load ──────────────────────────────────────────────
  Future<void> _onInitialized(
    SearchInitialized event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading());
    await Future.delayed(const Duration(milliseconds: 400));

    final results = _applyFilters(
      query: event.initialQuery,
      bloodGroups: const ['B+'],
      cities: const ['Dhaka'],
      availableOnly: false,
      sortBy: SearchSort.nearest,
    );

    emit(
      SearchLoaded(
        query: event.initialQuery.isEmpty
            ? 'B+ Positive, Dhaka'
            : event.initialQuery,
        results: results,
        totalFound: results.length,
        selectedBloodGroups: const ['B+'],
        selectedCities: const ['Dhaka'],
        availableOnly: false,
        sortBy: SearchSort.nearest,
      ),
    );
  }

  // ── Query changed ─────────────────────────────────────────────
  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final current = _currentLoaded;
    if (current == null) return;

    emit(const SearchLoading());
    await Future.delayed(const Duration(milliseconds: 300));

    final results = _applyFilters(
      query: event.query,
      bloodGroups: current.selectedBloodGroups,
      cities: current.selectedCities,
      availableOnly: current.availableOnly,
      sortBy: current.sortBy,
    );

    emit(
      current.copyWith(
        query: event.query,
        results: results,
        totalFound: results.length,
      ),
    );
  }

  // ── Blood group toggle ────────────────────────────────────────
  void _onBloodGroupToggled(
    SearchBloodGroupToggled event,
    Emitter<SearchState> emit,
  ) {
    final current = _currentLoaded;
    if (current == null) return;

    final groups = List<String>.from(current.selectedBloodGroups);
    if (groups.contains(event.bloodGroup)) {
      groups.remove(event.bloodGroup);
    } else {
      groups.add(event.bloodGroup);
    }

    final results = _applyFilters(
      query: current.query,
      bloodGroups: groups,
      cities: current.selectedCities,
      availableOnly: current.availableOnly,
      sortBy: current.sortBy,
    );

    emit(
      current.copyWith(
        selectedBloodGroups: groups,
        results: results,
        totalFound: results.length,
      ),
    );
  }

  // ── City toggle ───────────────────────────────────────────────
  void _onCityToggled(SearchCityToggled event, Emitter<SearchState> emit) {
    final current = _currentLoaded;
    if (current == null) return;

    final cities = List<String>.from(current.selectedCities);
    if (cities.contains(event.city)) {
      cities.remove(event.city);
    } else {
      cities.add(event.city);
    }

    final results = _applyFilters(
      query: current.query,
      bloodGroups: current.selectedBloodGroups,
      cities: cities,
      availableOnly: current.availableOnly,
      sortBy: current.sortBy,
    );

    emit(
      current.copyWith(
        selectedCities: cities,
        results: results,
        totalFound: results.length,
      ),
    );
  }

  // ── Availability toggle ───────────────────────────────────────
  void _onAvailabilityToggled(
    SearchAvailabilityToggled event,
    Emitter<SearchState> emit,
  ) {
    final current = _currentLoaded;
    if (current == null) return;

    final availableOnly = !current.availableOnly;

    final results = _applyFilters(
      query: current.query,
      bloodGroups: current.selectedBloodGroups,
      cities: current.selectedCities,
      availableOnly: availableOnly,
      sortBy: current.sortBy,
    );

    emit(
      current.copyWith(
        availableOnly: availableOnly,
        results: results,
        totalFound: results.length,
      ),
    );
  }

  // ── Sort changed ──────────────────────────────────────────────
  void _onSortChanged(SearchSortChanged event, Emitter<SearchState> emit) {
    final current = _currentLoaded;
    if (current == null) return;

    final results = _applyFilters(
      query: current.query,
      bloodGroups: current.selectedBloodGroups,
      cities: current.selectedCities,
      availableOnly: current.availableOnly,
      sortBy: event.sortBy,
    );

    emit(current.copyWith(sortBy: event.sortBy, results: results));
  }

  // ── Clear all filters ─────────────────────────────────────────
  void _onFiltersCleared(
    SearchFiltersCleared event,
    Emitter<SearchState> emit,
  ) {
    final allDonors = DonorModel.mockDonors;
    emit(
      SearchLoaded(
        query: '',
        results: allDonors,
        totalFound: allDonors.length,
        selectedBloodGroups: const [],
        selectedCities: const [],
        availableOnly: false,
        sortBy: SearchSort.nearest,
      ),
    );
  }

  // ── Filter logic ──────────────────────────────────────────────
  List<DonorModel> _applyFilters({
    required String query,
    required List<String> bloodGroups,
    required List<String> cities,
    required bool availableOnly,
    required SearchSort sortBy,
  }) {
    var donors = DonorModel.mockDonors.where((d) {
      // Query filter
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!d.name.toLowerCase().contains(q) &&
            !d.bloodGroup.toLowerCase().contains(q) &&
            !d.location.toLowerCase().contains(q)) {
          return false;
        }
      }

      // Blood group filter
      if (bloodGroups.isNotEmpty && !bloodGroups.contains(d.bloodGroup)) {
        return false;
      }

      // City filter
      if (cities.isNotEmpty && !cities.contains(d.city)) {
        return false;
      }

      // Availability filter
      if (availableOnly && !d.isAvailable) return false;

      return true;
    }).toList();

    // Sort
    if (sortBy == SearchSort.available) {
      donors.sort((a, b) => b.isAvailable ? 1 : -1);
    }

    return donors;
  }

  SearchLoaded? get _currentLoaded {
    final s = state;
    return s is SearchLoaded ? s : null;
  }
}
