part of 'purchased_all_songs_bloc.dart';

@immutable
abstract class PurchasedAllSongsEvent extends Equatable {}

class LoadAllPurchasedSongsEvent extends PurchasedAllSongsEvent {
  @override
  List<Object?> get props => [];
}
