part of 'iap_purchase_action_bloc.dart';

abstract class IapPurchaseActionState extends Equatable {
  const IapPurchaseActionState();
}

class IapPurchaseActionInitial extends IapPurchaseActionState {
  @override
  List<Object> get props => [];
}

class IapSongPurchaseActionState extends IapPurchaseActionState {
  const IapSongPurchaseActionState({
    required this.itemId,
    required this.appPurchasedSources,
  });

  final int itemId;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [itemId, appPurchasedSources];
}

class IapAlbumPurchaseActionState extends IapPurchaseActionState {
  const IapAlbumPurchaseActionState(
      {required this.itemId,
      required this.isFromSelfPage,
      required this.appPurchasedSources});

  final int itemId;
  final bool isFromSelfPage;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [itemId, isFromSelfPage, appPurchasedSources];
}

class IapPlaylistPurchaseActionState extends IapPurchaseActionState {
  const IapPlaylistPurchaseActionState(
      {required this.itemId,
      required this.isFromSelfPage,
      required this.appPurchasedSources});

  final int itemId;
  final bool isFromSelfPage;
  final AppPurchasedSources appPurchasedSources;

  @override
  List<Object?> get props => [itemId, isFromSelfPage, appPurchasedSources];
}
