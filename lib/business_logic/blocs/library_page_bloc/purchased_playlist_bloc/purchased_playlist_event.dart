part of 'purchased_playlist_bloc.dart';

abstract class PurchasedPlaylistEvent extends Equatable {
  const PurchasedPlaylistEvent();
}

class LoadPurchasedPlaylistsEvent extends PurchasedPlaylistEvent {
  @override
  List<Object?> get props => [];
}
