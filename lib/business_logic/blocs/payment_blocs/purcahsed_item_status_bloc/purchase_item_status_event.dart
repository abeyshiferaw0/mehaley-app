part of 'purchase_item_status_bloc.dart';

abstract class PurchaseItemStatusEvent extends Equatable {
  const PurchaseItemStatusEvent();
}

class CheckItemPurchaseStatusEvent extends PurchaseItemStatusEvent {
  CheckItemPurchaseStatusEvent({
    required this.itemId,
    required this.purchasedItemType,
    required this.itemImageUrl,
    required this.itemTitle,
    required this.itemSubTitle,
  });

  final int itemId;
  final PurchasedItemType purchasedItemType;
  final String itemImageUrl;
  final String itemTitle;
  final String itemSubTitle;

  @override
  List<Object?> get props => [
        itemId,
        purchasedItemType,
        itemImageUrl,
        itemTitle,
        itemSubTitle,
      ];
}
