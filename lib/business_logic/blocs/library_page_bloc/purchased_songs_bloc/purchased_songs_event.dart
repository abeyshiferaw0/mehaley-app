part of 'purchased_songs_bloc.dart';

@immutable
abstract class PurchasedSongsEvent extends Equatable {}

class LoadPurchasedSongsEvent extends PurchasedSongsEvent {
  @override
  List<Object?> get props => [];
}
