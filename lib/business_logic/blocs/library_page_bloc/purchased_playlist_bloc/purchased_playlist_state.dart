part of 'purchased_playlist_bloc.dart';

abstract class PurchasedPlaylistState extends Equatable {
  const PurchasedPlaylistState();
}

class PurchasedPlaylistInitial extends PurchasedPlaylistState {
  @override
  List<Object> get props => [];
}

class PurchasedPlaylistsLoadingState extends PurchasedPlaylistState {
  @override
  List<Object?> get props => [];
}

class PurchasedPlaylistsLoadingErrorState extends PurchasedPlaylistState {
  final String error;

  PurchasedPlaylistsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PurchasedPlaylistsLoadedState extends PurchasedPlaylistState {
  final List<PurchasedPlaylist> purchasedPlaylists;

  PurchasedPlaylistsLoadedState({required this.purchasedPlaylists});

  @override
  List<Object?> get props => [purchasedPlaylists];
}
