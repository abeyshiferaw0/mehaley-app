part of 'iap_subscription_page_bloc.dart';

abstract class IapSubscriptionPageEvent extends Equatable {
  const IapSubscriptionPageEvent();
}

class LoadIapSubscriptionOfferingsEvent extends IapSubscriptionPageEvent {
  const LoadIapSubscriptionOfferingsEvent();

  @override
  List<Object?> get props => [];
}
