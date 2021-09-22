part of 'purchased_albums_bloc.dart';

@immutable
abstract class PurchasedAlbumsState extends Equatable {}

class PurchasedAlbumsInitial extends PurchasedAlbumsState {
  @override
  List<Object?> get props => [];
}

class PurchasedAlbumsLoadedState extends PurchasedAlbumsState {
  final List<PurchasedAlbum> purchasedAlbums;

  PurchasedAlbumsLoadedState({required this.purchasedAlbums});

  @override
  List<Object?> get props => [purchasedAlbums];
}

class PurchasedAlbumsLoadingErrorState extends PurchasedAlbumsState {
  final String error;

  PurchasedAlbumsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PurchasedAlbumsLoadingState extends PurchasedAlbumsState {
  @override
  List<Object?> get props => [];
}
