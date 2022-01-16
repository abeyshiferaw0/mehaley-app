part of 'iap_subscription_restore_bloc.dart';

abstract class IapSubscriptionRestoreEvent extends Equatable {
  const IapSubscriptionRestoreEvent();
}

class RestoreIapSubscriptionEvent extends IapSubscriptionRestoreEvent {
  @override
  List<Object?> get props => [];
}
