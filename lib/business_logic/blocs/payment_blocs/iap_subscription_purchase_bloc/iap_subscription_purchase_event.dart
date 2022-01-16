part of 'iap_subscription_purchase_bloc.dart';

abstract class IapSubscriptionPurchaseEvent extends Equatable {
  const IapSubscriptionPurchaseEvent();
}

class PurchaseIapSubscriptionOfferingEvent
    extends IapSubscriptionPurchaseEvent {
  const PurchaseIapSubscriptionOfferingEvent({required this.offering});

  final Offering offering;

  @override
  List<Object?> get props => [offering];
}
