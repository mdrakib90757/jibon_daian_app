import 'package:equatable/equatable.dart';
import 'package:jibon_daian_app/features/search/data/model.dart';

enum SearchSort { nearest, latest, available }

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  const SearchLoaded({
    required this.query,
    required this.results,
    required this.totalFound,
    required this.selectedBloodGroups,
    required this.selectedCities,
    required this.availableOnly,
    required this.sortBy,
  });

  final String query;
  final List<DonorModel> results;
  final int totalFound;
  final List<String> selectedBloodGroups;
  final List<String> selectedCities;
  final bool availableOnly;
  final SearchSort sortBy;

  SearchLoaded copyWith({
    String? query,
    List<DonorModel>? results,
    int? totalFound,
    List<String>? selectedBloodGroups,
    List<String>? selectedCities,
    bool? availableOnly,
    SearchSort? sortBy,
  }) {
    return SearchLoaded(
      query: query ?? this.query,
      results: results ?? this.results,
      totalFound: totalFound ?? this.totalFound,
      selectedBloodGroups: selectedBloodGroups ?? this.selectedBloodGroups,
      selectedCities: selectedCities ?? this.selectedCities,
      availableOnly: availableOnly ?? this.availableOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [
    query,
    results,
    totalFound,
    selectedBloodGroups,
    selectedCities,
    availableOnly,
    sortBy,
  ];
}

class SearchFailure extends SearchState {
  const SearchFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
