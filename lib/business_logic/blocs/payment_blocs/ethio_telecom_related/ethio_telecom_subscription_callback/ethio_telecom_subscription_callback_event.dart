part of 'ethio_telecom_subscription_callback_bloc.dart';

abstract class EthioTelecomSubscriptionCallbackEvent extends Equatable {
  const EthioTelecomSubscriptionCallbackEvent();
}

class EthioTeleSubCallbackEvent extends EthioTelecomSubscriptionCallbackEvent {
  final Headers headers;

  EthioTeleSubCallbackEvent({required this.headers});

  @override
  List<Object?> get props => [headers];
}
