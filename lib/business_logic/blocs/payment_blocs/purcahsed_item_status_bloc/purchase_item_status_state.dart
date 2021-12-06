part of 'purchase_item_status_bloc.dart';

abstract class PurchaseItemStatusState extends Equatable {
  const PurchaseItemStatusState();
}

class PurchaseItemStatusInitial extends PurchaseItemStatusState {
  @override
  List<Object> get props => [];
}

class PurchaseItemStatusLoadingState extends PurchaseItemStatusState {
  @override
  List<Object?> get props => [];
}

class PurchaseItemStatusLoadingErrorState extends PurchaseItemStatusState {
  final String error;

  PurchaseItemStatusLoadingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class PurchaseItemStatusLoadedState extends PurchaseItemStatusState {
  final PurchaseItemStatusData purchaseItemStatusData;
  final String itemImageUrl;
  final String itemTitle;
  final String itemSubTitle;
  final PurchasedItemType purchasedItemType;

  PurchaseItemStatusLoadedState({
    required this.purchaseItemStatusData,
    required this.itemImageUrl,
    required this.itemTitle,
    required this.itemSubTitle,
    required this.purchasedItemType,
  });

  @override
  List<Object?> get props => [
        purchaseItemStatusData,
        itemImageUrl,
        itemTitle,
        itemSubTitle,
        purchasedItemType,
      ];
}
