part of 'ethio_telecom_payment_bloc.dart';

abstract class EthioTelecomPaymentState extends Equatable {
  const EthioTelecomPaymentState();
}

class EthioTelecomPaymentInitial extends EthioTelecomPaymentState {
  @override
  List<Object> get props => [];
}

class EthioTelecomPurchasingState extends EthioTelecomPaymentState {
  @override
  List<Object> get props => [];
}

class EthioTelecomPurchasedState extends EthioTelecomPaymentState {
  final int itemId;

  EthioTelecomPurchasedState({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class EthioTelecomPurchaseBalanceNotEnoughState
    extends EthioTelecomPaymentState {
  final DateTime dateTime;

  EthioTelecomPurchaseBalanceNotEnoughState({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class EthioTelecomPurchaseNoInternetState extends EthioTelecomPaymentState {
  final DateTime dateTime;

  EthioTelecomPurchaseNoInternetState({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class EthioTelecomPurchasingFailedState extends EthioTelecomPaymentState {
  final String error;
  final DateTime dateTime;

  EthioTelecomPurchasingFailedState(
      {required this.dateTime, required this.error});

  @override
  List<Object> get props => [error, dateTime];
}
