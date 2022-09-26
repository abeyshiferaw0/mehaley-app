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

class EthioTelecomPurchasingFailedState extends EthioTelecomPaymentState {
  final String error;
  final DateTime dateTime;

  EthioTelecomPurchasingFailedState(
      {required this.dateTime, required this.error});

  @override
  List<Object> get props => [error, dateTime];
}

class EthioTelecomPurchasedIsFreeState extends EthioTelecomPaymentState {
  final int itemId;
  final TelePaymentResultData telePaymentResultData;
  final PurchasedItemType purchasedItemType;

  EthioTelecomPurchasedIsFreeState({
    required this.itemId,
    required this.telePaymentResultData,
    required this.purchasedItemType,
  });

  @override
  List<Object> get props => [
        itemId,
        purchasedItemType,
        telePaymentResultData,
      ];
}

class EthioTelecomIsAlreadyBoughtState extends EthioTelecomPaymentState {
  final int itemId;
  final TelePaymentResultData telePaymentResultData;
  final PurchasedItemType purchasedItemType;

  EthioTelecomIsAlreadyBoughtState({
    required this.itemId,
    required this.telePaymentResultData,
    required this.purchasedItemType,
  });

  @override
  List<Object> get props => [
        itemId,
        purchasedItemType,
        telePaymentResultData,
      ];
}

class EthioTelecomPurchasedSuccessState extends EthioTelecomPaymentState {
  final int itemId;
  final TelePaymentResultData telePaymentResultData;
  final PurchasedItemType purchasedItemType;

  EthioTelecomPurchasedSuccessState({
    required this.itemId,
    required this.telePaymentResultData,
    required this.purchasedItemType,
  });

  @override
  List<Object> get props => [
        itemId,
        purchasedItemType,
        telePaymentResultData,
      ];
}

class EthioTelecomPurchaseNotSuccessState extends EthioTelecomPaymentState {
  final int itemId;
  final TelePaymentResultData telePaymentResultData;
  final PurchasedItemType purchasedItemType;

  EthioTelecomPurchaseNotSuccessState({
    required this.itemId,
    required this.telePaymentResultData,
    required this.purchasedItemType,
  });

  @override
  List<Object> get props => [
        itemId,
        purchasedItemType,
        telePaymentResultData,
      ];
}

class EthioTelecomPurchaseBalanceNotEnoughState
    extends EthioTelecomPaymentState {
  final int itemId;
  final TelePaymentResultData telePaymentResultData;
  final PurchasedItemType purchasedItemType;

  EthioTelecomPurchaseBalanceNotEnoughState({
    required this.itemId,
    required this.telePaymentResultData,
    required this.purchasedItemType,
  });

  @override
  List<Object> get props => [
        itemId,
        purchasedItemType,
        telePaymentResultData,
      ];
}
