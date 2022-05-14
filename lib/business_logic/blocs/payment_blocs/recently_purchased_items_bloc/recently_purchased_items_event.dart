part of 'recently_purchased_items_bloc.dart';

abstract class RecentlyPurchasedItemsEvent extends Equatable {
  const RecentlyPurchasedItemsEvent();
}

class SaveRecentlyPurchasedItemEvent extends RecentlyPurchasedItemsEvent {
  const SaveRecentlyPurchasedItemEvent(
      {required this.item, required this.purchasedItemType});

  final dynamic item;
  final PurchasedItemType purchasedItemType;

  @override
  List<Object?> get props => [item, purchasedItemType];
}
