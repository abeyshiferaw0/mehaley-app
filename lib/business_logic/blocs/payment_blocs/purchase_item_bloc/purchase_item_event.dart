part of 'purchase_item_bloc.dart';

abstract class PurchaseItemEvent extends Equatable {
  const PurchaseItemEvent();
}

class PurchaseItem extends PurchaseItemEvent {
  PurchaseItem({
    required this.itemId,
    required this.purchasedItemType,
  });

  final int itemId;
  final PurchasedItemType purchasedItemType;

  @override
  List<Object?> get props => [
        itemId,
        purchasedItemType,
      ];
}
