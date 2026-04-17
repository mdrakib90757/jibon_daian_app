import 'package:equatable/equatable.dart';
import 'package:jibon_Bachan_app/features/donate_blood/data/model/donate_blood_model.dart';

abstract class DonateBloodState extends Equatable {
  const DonateBloodState();
  @override
  List<Object?> get props => [];
}

class DonateBloodInitial extends DonateBloodState {
  const DonateBloodInitial();
}

class DonateBloodLoading extends DonateBloodState {
  const DonateBloodLoading();
}

class DonateBloodLoadedState extends DonateBloodState {
  const DonateBloodLoadedState({
    required this.donorInfo,
    required this.allCenters,
    required this.filteredCenters,
    this.searchQuery = '',
  });

  final DonateDonorInfoModel donorInfo;
  final List<DonationCenterModel> allCenters;
  final List<DonationCenterModel> filteredCenters;
  final String searchQuery;

  DonateBloodLoadedState copyWith({
    DonateDonorInfoModel? donorInfo,
    List<DonationCenterModel>? allCenters,
    List<DonationCenterModel>? filteredCenters,
    String? searchQuery,
  }) {
    return DonateBloodLoadedState(
      donorInfo: donorInfo ?? this.donorInfo,
      allCenters: allCenters ?? this.allCenters,
      filteredCenters: filteredCenters ?? this.filteredCenters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [donorInfo, filteredCenters, searchQuery];
}

class DonateBloodRegisterSuccess extends DonateBloodState {
  const DonateBloodRegisterSuccess();
}

class DonateBloodError extends DonateBloodState {
  const DonateBloodError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
