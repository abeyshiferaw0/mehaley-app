part of 'iap_subscription_status_bloc.dart';

abstract class IapSubscriptionStatusEvent extends Equatable {
  const IapSubscriptionStatusEvent();
}

class CheckIapSubscriptionEvent extends IapSubscriptionStatusEvent {
  @override
  List<Object?> get props => [];
}
