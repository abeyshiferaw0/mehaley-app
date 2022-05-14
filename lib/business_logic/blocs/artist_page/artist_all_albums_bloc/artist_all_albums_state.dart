part of 'artist_all_albums_bloc.dart';

abstract class ArtistAllAlbumsState extends Equatable {
  const ArtistAllAlbumsState();
}

class ArtistAllAlbumsInitial extends ArtistAllAlbumsState {
  @override
  List<Object> get props => [];
}

class AllPaginatedAlbumsLoadingState extends ArtistAllAlbumsState {
  @override
  List<Object> get props => [];
}

class AllPaginatedAlbumsLoadedState extends ArtistAllAlbumsState {
  final List<Album> paginatedAlbums;
  final int page;
  final int artistId;

  AllPaginatedAlbumsLoadedState({
    required this.paginatedAlbums,
    required this.page,
    required this.artistId,
  });

  @override
  List<Object> get props => [paginatedAlbums, page, artistId];
}

class AllPaginatedAlbumsLoadingErrorState extends ArtistAllAlbumsState {
  final String error;

  AllPaginatedAlbumsLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
