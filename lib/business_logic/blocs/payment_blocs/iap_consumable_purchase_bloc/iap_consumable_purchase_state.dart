part of 'iap_consumable_purchase_bloc.dart';

abstract class IapConsumablePurchaseState extends Equatable {
  const IapConsumablePurchaseState();
}

class IapConsumablePurchaseInitial extends IapConsumablePurchaseState {
  @override
  List<Object> get props => [];
}

class IapConsumablePurchaseStartedState extends IapConsumablePurchaseState {
  @override
  List<Object> get props => [];
}

class IapConsumablePurchaseErrorState extends IapConsumablePurchaseState {
  final String error;
  final DateTime dateTime;

  IapConsumablePurchaseErrorState(
      {required this.error, required this.dateTime});
  @override
  List<Object?> get props => [error, dateTime];
}

class IapConsumablePurchaseNoInternetState extends IapConsumablePurchaseState {
  final DateTime dateTime;

  IapConsumablePurchaseNoInternetState({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class IapNotAvailableState extends IapConsumablePurchaseState {
  final DateTime dateTime;

  IapNotAvailableState({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class ShowIapPurchasePendingState extends IapConsumablePurchaseState {
  final DateTime dateTime;

  ShowIapPurchasePendingState({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class IapPurchaseSuccessVerifyState extends IapConsumablePurchaseState {
  final int itemId;
  final AppPurchasedItemType appPurchasedItemType;
  final PurchasedItem purchasedItem;
  final bool isFromSelfPage;
  final String purchaseToken;
  final AppPurchasedSources appPurchasedSources;

  IapPurchaseSuccessVerifyState({
    required this.itemId,
    required this.appPurchasedItemType,
    required this.purchasedItem,
    required this.isFromSelfPage,
    required this.purchaseToken,
    required this.appPurchasedSources,
  });
  @override
  List<Object?> get props => [
        itemId,
        purchasedItem,
        isFromSelfPage,
        appPurchasedItemType,
        purchaseToken,
        appPurchasedSources,
      ];
}
