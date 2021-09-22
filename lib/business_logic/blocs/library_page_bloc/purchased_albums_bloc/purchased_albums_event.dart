part of 'purchased_albums_bloc.dart';

@immutable
abstract class PurchasedAlbumsEvent extends Equatable {}

class LoadPurchasedAlbumsEvent extends PurchasedAlbumsEvent {
  @override
  List<Object?> get props => [];
}
