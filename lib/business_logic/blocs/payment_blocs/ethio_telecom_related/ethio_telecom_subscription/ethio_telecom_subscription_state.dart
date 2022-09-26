part of 'ethio_telecom_subscription_bloc.dart';

abstract class EthioTelecomSubscriptionState extends Equatable {
  const EthioTelecomSubscriptionState();
}

class EthioTelecomSubscriptionInitial extends EthioTelecomSubscriptionState {
  @override
  List<Object> get props => [];
}

class EthioTeleSubscriptionLoadingState extends EthioTelecomSubscriptionState {
  @override
  List<Object> get props => [];
}

class EthioTeleSubscriptionLoadedState extends EthioTelecomSubscriptionState {
  final List<EthioTeleSubscriptionOfferings> ethioTeleSubscriptionOfferings;

  EthioTeleSubscriptionLoadedState(
      {required this.ethioTeleSubscriptionOfferings});

  @override
  List<Object> get props => [ethioTeleSubscriptionOfferings];
}

class EthioTeleSubscriptionLoadingErrorState
    extends EthioTelecomSubscriptionState {
  final String error;
  final DateTime dateTime;

  EthioTeleSubscriptionLoadingErrorState({
    required this.error,
    required this.dateTime,
  });

  @override
  List<Object> get props => [error, dateTime];
}
