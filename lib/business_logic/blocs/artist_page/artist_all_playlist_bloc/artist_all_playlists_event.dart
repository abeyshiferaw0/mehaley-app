part of 'artist_all_playlists_bloc.dart';

abstract class ArtistAllPlaylistsEvent extends Equatable {
  const ArtistAllPlaylistsEvent();
}

class LoadAllPaginatedPlaylistsEvent extends ArtistAllPlaylistsEvent {
  final int pageSize;
  final int page;
  final int artistId;

  LoadAllPaginatedPlaylistsEvent({
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
