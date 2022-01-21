part of 'iap_purchase_action_bloc.dart';

abstract class IapPurchaseActionEvent extends Equatable {
  const IapPurchaseActionEvent();
}

class IapSongPurchaseActionEvent extends IapPurchaseActionEvent {
  const IapSongPurchaseActionEvent(
      {required this.itemId, required this.appPurchasedSources});

  final int itemId;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [itemId, appPurchasedSources];
}

class IapAlbumPurchaseActionEvent extends IapPurchaseActionEvent {
  const IapAlbumPurchaseActionEvent(
      {required this.itemId,
      required this.isFromSelfPage,
      required this.appPurchasedSources});

  final int itemId;
  final bool isFromSelfPage;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [itemId, isFromSelfPage, appPurchasedSources];
}

class IapPlaylistPurchaseActionEvent extends IapPurchaseActionEvent {
  const IapPlaylistPurchaseActionEvent({
    required this.itemId,
    required this.isFromSelfPage,
    required this.appPurchasedSources,
  });

  final int itemId;
  final bool isFromSelfPage;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [
        itemId,
        isFromSelfPage,
        appPurchasedSources,
      ];
}
