part of 'all_playlists_page_bloc.dart';

abstract class AllPlaylistsPageState extends Equatable {
  const AllPlaylistsPageState();
}

class AllPlaylistsPageInitial extends AllPlaylistsPageState {
  @override
  List<Object> get props => [];
}

class AllPaginatedPlaylistsLoadingState extends AllPlaylistsPageState {
  @override
  List<Object> get props => [];
}

class AllPaginatedPlaylistsLoadedState extends AllPlaylistsPageState {
  final List<Playlist> paginatedPlaylists;
  final int page;

  AllPaginatedPlaylistsLoadedState({
    required this.paginatedPlaylists,
    required this.page,
  });

  @override
  List<Object> get props => [paginatedPlaylists, page];
}

class AllPaginatedPlaylistsLoadingErrorState extends AllPlaylistsPageState {
  final String error;

  AllPaginatedPlaylistsLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
