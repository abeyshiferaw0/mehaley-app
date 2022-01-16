part of 'recently_purchased_items_bloc.dart';

abstract class RecentlyPurchasedItemsEvent extends Equatable {
  const RecentlyPurchasedItemsEvent();
}

class SaveRecentlyPurchasedItemEvent extends RecentlyPurchasedItemsEvent {
  const SaveRecentlyPurchasedItemEvent(
      {required this.item, required this.appPurchasedItemType});

  final dynamic item;
  final AppPurchasedItemType appPurchasedItemType;

  @override
  List<Object?> get props => [item, appPurchasedItemType];
}
