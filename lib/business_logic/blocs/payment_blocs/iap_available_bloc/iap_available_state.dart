part of 'iap_available_bloc.dart';

abstract class IapAvailableState extends Equatable {
  const IapAvailableState();
}

class IapAvailableInitial extends IapAvailableState {
  @override
  List<Object> get props => [];
}

class IapAvailabilityCheckedState extends IapAvailableState {
  @override
  List<Object?> get props => [];
}
