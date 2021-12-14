part of 'purchased_all_songs_bloc.dart';

@immutable
abstract class PurchasedAllSongsEvent extends Equatable {}

class LoadAllPurchasedSongsEvent extends PurchasedAllSongsEvent {
  @override
  List<Object?> get props => [];
}

class LoadAllPaginatedPurchasedSongsEvent extends PurchasedAllSongsEvent {
  final int pageSize;
  final int page;

  LoadAllPaginatedPurchasedSongsEvent(
      {required this.pageSize, required this.page});

  @override
  List<Object?> get props => [
        pageSize,
        page,
      ];
}

class RefreshAllPurchasedSongsEvent extends PurchasedAllSongsEvent {
  @override
  List<Object?> get props => [];
}
