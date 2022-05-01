part of 'ethio_telecom_payment_bloc.dart';

abstract class EthioTelecomPaymentEvent extends Equatable {
  const EthioTelecomPaymentEvent();
}

class StartEthioTelecomPaymentEvent extends EthioTelecomPaymentEvent {
  StartEthioTelecomPaymentEvent({
    required this.itemId,
    required this.appPurchasedItemType,
    required this.isFromItemSelfPage,
    required this.appPurchasedSources,
  });

  final int itemId;
  final AppPurchasedItemType appPurchasedItemType;
  final bool isFromItemSelfPage;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [
        itemId,
        appPurchasedItemType,
        isFromItemSelfPage,
        appPurchasedSources,
      ];
}
