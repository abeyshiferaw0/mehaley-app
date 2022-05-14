part of 'artist_all_albums_bloc.dart';

abstract class ArtistAllAlbumsEvent extends Equatable {
  const ArtistAllAlbumsEvent();
}

class LoadAllPaginatedAlbumsEvent extends ArtistAllAlbumsEvent {
  final int pageSize;
  final int page;
  final int artistId;

  LoadAllPaginatedAlbumsEvent({
    required this.pageSize,
    required this.page,
    required this.artistId,
  });

  @override
  List<Object?> get props => [
        pageSize,
        page,
        artistId,
      ];
}
