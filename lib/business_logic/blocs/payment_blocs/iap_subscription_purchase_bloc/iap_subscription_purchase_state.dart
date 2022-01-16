part of 'iap_subscription_purchase_bloc.dart';

abstract class IapSubscriptionPurchaseState extends Equatable {
  const IapSubscriptionPurchaseState();
}

class IapSubscriptionPurchaseInitial extends IapSubscriptionPurchaseState {
  @override
  List<Object> get props => [];
}

class IapSubscriptionPurchasingState extends IapSubscriptionPurchaseState {
  @override
  List<Object> get props => [];
}

class IapSubscriptionPurchasedState extends IapSubscriptionPurchaseState {
  final bool isSubscribed;

  IapSubscriptionPurchasedState({required this.isSubscribed});

  @override
  List<Object> get props => [isSubscribed];
}

class IapSubscriptionPurchasingErrorState extends IapSubscriptionPurchaseState {
  final String error;

  IapSubscriptionPurchasingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
