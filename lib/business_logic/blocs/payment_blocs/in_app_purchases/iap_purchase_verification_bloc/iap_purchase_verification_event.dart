part of 'iap_purchase_verification_bloc.dart';

abstract class IapPurchaseVerificationEvent extends Equatable {
  const IapPurchaseVerificationEvent();
}

class IapPurchaseVerifyEvent extends IapPurchaseVerificationEvent {
  final int itemId;
  final AppPurchasedItemType appPurchasedItemType;
  final PurchasedItem purchasedItem;
  final String purchaseToken;

  IapPurchaseVerifyEvent(
      {required this.itemId,
      required this.appPurchasedItemType,
      required this.purchasedItem,
      required this.purchaseToken});

  @override
  List<Object?> get props => [
        itemId,
        appPurchasedItemType,
        purchasedItem,
        purchaseToken,
      ];
}
