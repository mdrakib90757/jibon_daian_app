
import 'package:equatable/equatable.dart';

abstract class HospitalEvent extends Equatable {
  const HospitalEvent();
  @override
  List<Object?> get props => [];
}

class HospitalLoaded extends HospitalEvent {
  const HospitalLoaded();
}

class HospitalSearchChanged extends HospitalEvent {
  const HospitalSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class HospitalViewToggled extends HospitalEvent {
  const HospitalViewToggled(this.isListView);
  final bool isListView;
  @override
  List<Object?> get props => [isListView];
}
