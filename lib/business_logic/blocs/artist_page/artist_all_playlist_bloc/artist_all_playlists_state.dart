part of 'artist_all_playlists_bloc.dart';

abstract class ArtistAllPlaylistsState extends Equatable {
  const ArtistAllPlaylistsState();
}

class ArtistAllPlaylistsInitial extends ArtistAllPlaylistsState {
  @override
  List<Object> get props => [];
}

class AllPaginatedPlaylistsLoadingState extends ArtistAllPlaylistsState {
  @override
  List<Object> get props => [];
}

class AllPaginatedPlaylistsLoadedState extends ArtistAllPlaylistsState {
  final List<Playlist> paginatedPlaylists;
  final int page;
  final int artistId;

  AllPaginatedPlaylistsLoadedState({
    required this.paginatedPlaylists,
    required this.page,
    required this.artistId,
  });

  @override
  List<Object> get props => [paginatedPlaylists, page, artistId];
}

class AllPaginatedPlaylistsLoadingErrorState extends ArtistAllPlaylistsState {
  final String error;

  AllPaginatedPlaylistsLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
