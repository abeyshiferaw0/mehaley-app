part of 'ethio_telecom_subscription_bloc.dart';

abstract class EthioTelecomSubscriptionEvent extends Equatable {
  const EthioTelecomSubscriptionEvent();
}

class LoadEthioTeleSubscriptionOfferingsEvent
    extends EthioTelecomSubscriptionEvent {
  const LoadEthioTeleSubscriptionOfferingsEvent();

  @override
  List<Object?> get props => [];
}
