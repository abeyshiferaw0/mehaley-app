part of 'purchase_item_bloc.dart';

abstract class PurchaseItemState extends Equatable {
  const PurchaseItemState();
}

class PurchaseItemInitial extends PurchaseItemState {
  @override
  List<Object> get props => [];
}

///FOR ITEM PAYMENT
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
  final int itemId;
  final PurchasedItemType purchasedItemType;

  PurchaseItemLoadedState({
    required this.itemId,
    required this.purchasedItemType,
  });

  @override
  List<Object?> get props => [
        itemId,
        purchasedItemType,
      ];
}

///FOR CART CHECKOUT
class CheckOutLoadingState extends PurchaseItemState {
  @override
  List<Object?> get props => [];
}

class CheckOutLoadingErrorState extends PurchaseItemState {
  final String error;

  CheckOutLoadingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class CheckOutLoadedState extends PurchaseItemState {
  @override
  List<Object?> get props => [];
}
