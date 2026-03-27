import 'package:equatable/equatable.dart';
import 'package:jibon_daian_app/features/search/bloc/search_state.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

/// Initial load with optional pre-filled query
class SearchInitialized extends SearchEvent {
  const SearchInitialized({this.initialQuery = ''});
  final String initialQuery;
  @override
  List<Object?> get props => [initialQuery];
}

/// User typed in search box
class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

/// User selected/deselected a blood group chip
class SearchBloodGroupToggled extends SearchEvent {
  const SearchBloodGroupToggled(this.bloodGroup);
  final String bloodGroup;
  @override
  List<Object?> get props => [bloodGroup];
}

/// User selected/deselected a city chip
class SearchCityToggled extends SearchEvent {
  const SearchCityToggled(this.city);
  final String city;
  @override
  List<Object?> get props => [city];
}

/// User toggled Available Only filter
class SearchAvailabilityToggled extends SearchEvent {
  const SearchAvailabilityToggled();
}

/// Sort changed
class SearchSortChanged extends SearchEvent {
  const SearchSortChanged(this.sortBy);
  final SearchSort sortBy;
  @override
  List<Object?> get props => [sortBy];
}

/// All filters cleared
class SearchFiltersCleared extends SearchEvent {
  const SearchFiltersCleared();
}
