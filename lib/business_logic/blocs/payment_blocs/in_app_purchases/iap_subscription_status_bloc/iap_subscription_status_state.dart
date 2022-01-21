part of 'iap_subscription_status_bloc.dart';

abstract class IapSubscriptionStatusState extends Equatable {
  const IapSubscriptionStatusState();
}

class IapSubscriptionStatusInitial extends IapSubscriptionStatusState {
  @override
  List<Object> get props => [];
}

class IapSubscriptionStatusCheckingState extends IapSubscriptionStatusState {
  @override
  List<Object> get props => [];
}

class IapSubscriptionStatusCheckedState extends IapSubscriptionStatusState {
  final bool isSubscribedEnded;

  IapSubscriptionStatusCheckedState({required this.isSubscribedEnded});

  @override
  List<Object> get props => [isSubscribedEnded];
}

class IapSubscriptionStatusCheckingErrorState
    extends IapSubscriptionStatusState {
  final String error;

  IapSubscriptionStatusCheckingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
