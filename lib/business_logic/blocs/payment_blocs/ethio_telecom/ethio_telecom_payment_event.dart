part of 'ethio_telecom_payment_bloc.dart';

abstract class EthioTelecomPaymentEvent extends Equatable {
  const EthioTelecomPaymentEvent();
}

class StartEthioTelecomPaymentEvent extends EthioTelecomPaymentEvent {
  StartEthioTelecomPaymentEvent({
    required this.itemId,
    required this.purchasedItemType,
    required this.isFromItemSelfPage,
    required this.appPurchasedSources,
  });

  final int itemId;
  final PurchasedItemType purchasedItemType;
  final bool isFromItemSelfPage;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [
        itemId,
        purchasedItemType,
        isFromItemSelfPage,
        appPurchasedSources,
      ];
}
