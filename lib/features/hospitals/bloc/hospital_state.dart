import 'package:equatable/equatable.dart';

import '../data/model/hospital_model.dart';

abstract class HospitalState extends Equatable {
  const HospitalState();
  @override
  List<Object?> get props => [];
}

class HospitalInitial extends HospitalState {
  const HospitalInitial();
}

class HospitalLoading extends HospitalState {
  const HospitalLoading();
}

class HospitalLoadedState extends HospitalState {
  const HospitalLoadedState({
    required this.hospitals,
    required this.filteredHospitals,
    required this.urgentCount,
    required this.urgentBloodGroup,
    required this.isListView,
    this.searchQuery = '',
  });

  final List<HospitalModel> hospitals;
  final List<HospitalModel> filteredHospitals;
  final int urgentCount;
  final String urgentBloodGroup;
  final bool isListView;
  final String searchQuery;

  HospitalLoadedState copyWith({
    List<HospitalModel>? hospitals,
    List<HospitalModel>? filteredHospitals,
    int? urgentCount,
    String? urgentBloodGroup,
    bool? isListView,
    String? searchQuery,
  }) {
    return HospitalLoadedState(
      hospitals: hospitals ?? this.hospitals,
      filteredHospitals: filteredHospitals ?? this.filteredHospitals,
      urgentCount: urgentCount ?? this.urgentCount,
      urgentBloodGroup: urgentBloodGroup ?? this.urgentBloodGroup,
      isListView: isListView ?? this.isListView,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    filteredHospitals,
    urgentCount,
    isListView,
    searchQuery,
  ];
}

class HospitalError extends HospitalState {
  const HospitalError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
