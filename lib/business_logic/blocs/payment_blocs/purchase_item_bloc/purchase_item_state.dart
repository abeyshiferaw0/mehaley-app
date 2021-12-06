part of 'purchase_item_bloc.dart';

abstract class PurchaseItemState extends Equatable {
  const PurchaseItemState();
}

class PurchaseItemInitial extends PurchaseItemState {
  @override
  List<Object> get props => [];
}


class PurchaseItemLoadingState extends PurchaseItemState {
  @override
  List<Object?> get props => [];
}

class PurchaseItemLoadingErrorState extends PurchaseItemState {
  final String error;

  PurchaseItemLoadingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class PurchaseItemLoadedState extends PurchaseItemState {
  final PurchaseItemStatusData purchaseItemStatusData;
  final PurchasedItemType purchasedItemType;

  PurchaseItemLoadedState({
    required this.purchaseItemStatusData,
    required this.purchasedItemType,
  });

  @override
  List<Object?> get props => [
    purchaseItemStatusData,
    purchasedItemType,
  ];
}
