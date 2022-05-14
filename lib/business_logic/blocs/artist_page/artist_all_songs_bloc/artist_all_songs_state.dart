part of 'artist_all_songs_bloc.dart';

abstract class ArtistAllSongsState extends Equatable {
  const ArtistAllSongsState();
}

class ArtistAllSongsInitial extends ArtistAllSongsState {
  @override
  List<Object> get props => [];
}

class AllPaginatedSongsLoadingState extends ArtistAllSongsState {
  @override
  List<Object> get props => [];
}

class AllPaginatedSongsLoadedState extends ArtistAllSongsState {
  final List<Song> paginatedSongs;
  final int page;
  final int artistId;

  AllPaginatedSongsLoadedState({
    required this.paginatedSongs,
    required this.page,
    required this.artistId,
  });

  @override
  List<Object> get props => [paginatedSongs, page, artistId];
}

class AllPaginatedSongsLoadingErrorState extends ArtistAllSongsState {
  final String error;

  AllPaginatedSongsLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
