part of 'iap_subscription_page_bloc.dart';

abstract class IapSubscriptionPageState extends Equatable {
  const IapSubscriptionPageState();
}

class IapSubscriptionInitial extends IapSubscriptionPageState {
  @override
  List<Object> get props => [];
}

class IapSubscriptionLoadingState extends IapSubscriptionPageState {
  @override
  List<Object> get props => [];
}

class IapSubscriptionLoadedState extends IapSubscriptionPageState {
  final List<SubscriptionOfferings> subscriptionOfferingsList;

  IapSubscriptionLoadedState({required this.subscriptionOfferingsList});

  @override
  List<Object> get props => [subscriptionOfferingsList];
}

class IapSubscriptionLoadingErrorState extends IapSubscriptionPageState {
  final String error;

  IapSubscriptionLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class IapNotAvailableErrorState extends IapSubscriptionPageState {
  IapNotAvailableErrorState();

  @override
  List<Object> get props => [];
}
