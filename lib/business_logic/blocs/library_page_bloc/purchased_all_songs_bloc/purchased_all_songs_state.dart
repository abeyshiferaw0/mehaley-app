part of 'purchased_all_songs_bloc.dart';

@immutable
abstract class PurchasedAllSongsState extends Equatable {}

class PurchasedAllSongsInitial extends PurchasedAllSongsState {
  @override
  List<Object?> get props => [];
}

class PurchasedAllSongsLoadingState extends PurchasedAllSongsState {
  @override
  List<Object?> get props => [];
}

class PurchasedAllSongsLoadingErrorState extends PurchasedAllSongsState {
  final String error;

  PurchasedAllSongsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class AllPurchasedSongsLoadedState extends PurchasedAllSongsState {
  final List<PurchasedSong> allPurchasedSong;

  AllPurchasedSongsLoadedState({required this.allPurchasedSong});

  @override
  List<Object?> get props => [allPurchasedSong];
}
