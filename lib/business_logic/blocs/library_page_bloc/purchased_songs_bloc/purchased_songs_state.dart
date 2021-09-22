part of 'purchased_songs_bloc.dart';

@immutable
abstract class PurchasedSongsState extends Equatable {}

class PurchasedSongsInitial extends PurchasedSongsState {
  @override
  List<Object?> get props => [];
}

class PurchasedSongsLoadedState extends PurchasedSongsState {
  final List<PurchasedSong> purchasedSongs;

  PurchasedSongsLoadedState({required this.purchasedSongs});

  @override
  List<Object?> get props => [purchasedSongs];
}

class PurchasedSongsLoadingErrorState extends PurchasedSongsState {
  final String error;

  PurchasedSongsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PurchasedSongsLoadingState extends PurchasedSongsState {
  @override
  List<Object?> get props => [];
}
