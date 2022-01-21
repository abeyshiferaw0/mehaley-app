part of 'iap_available_bloc.dart';

abstract class IapAvailableEvent extends Equatable {
  const IapAvailableEvent();
}

class CheckIapAvailabilityEvent extends IapAvailableEvent {
  @override
  List<Object?> get props => [];
}
