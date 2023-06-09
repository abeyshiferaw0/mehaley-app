part of 'iap_consumable_purchase_bloc.dart';

abstract class IapConsumablePurchaseEvent extends Equatable {
  const IapConsumablePurchaseEvent();
}

class StartConsumablePurchaseEvent extends IapConsumablePurchaseEvent {
  StartConsumablePurchaseEvent({
    required this.iapProduct,
    required this.itemId,
    required this.purchasedItemType,
    required this.isFromItemSelfPage,
    required this.appPurchasedSources,
  });

  final int itemId;
  final PurchasedItemType purchasedItemType;
  final bool isFromItemSelfPage;
  final IapProduct iapProduct;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [
        iapProduct,
        itemId,
        purchasedItemType,
        isFromItemSelfPage,
        appPurchasedSources,
      ];
}

class ShowIapPurchasePendingEvent extends IapConsumablePurchaseEvent {
  final DateTime dateTime;

  ShowIapPurchasePendingEvent({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class IapPurchaseShowErrorEvent extends IapConsumablePurchaseEvent {
  final String error;
  final DateTime dateTime;

  IapPurchaseShowErrorEvent({required this.dateTime, required this.error});
  @override
  List<Object?> get props => [error, dateTime];
}

class IapPurchaseCanceledEvent extends IapConsumablePurchaseEvent {
  final DateTime dateTime;

  IapPurchaseCanceledEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class IapPurchaseSuccessVerifyEvent extends IapConsumablePurchaseEvent {
  final int itemId;
  final PurchasedItemType purchasedItemType;
  final bool isFromSelfPage;
  final PurchasedItem purchasedItem;
  final String purchaseToken;
  final AppPurchasedSources appPurchasedSources;

  IapPurchaseSuccessVerifyEvent({
    required this.itemId,
    required this.purchasedItemType,
    required this.purchasedItem,
    required this.isFromSelfPage,
    required this.purchaseToken,
    required this.appPurchasedSources,
  });
  @override
  List<Object?> get props => [
        itemId,
        purchasedItem,
        purchaseToken,
        isFromSelfPage,
        purchasedItemType,
        appPurchasedSources
      ];
}
