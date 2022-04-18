part of 'all_artists_page_bloc.dart';

abstract class AllArtistsPageState extends Equatable {
  const AllArtistsPageState();
}

class AllArtistsPageInitial extends AllArtistsPageState {
  @override
  List<Object> get props => [];
}

class AllPaginatedArtistsLoadingState extends AllArtistsPageState {
  @override
  List<Object> get props => [];
}

class AllPaginatedArtistsLoadedState extends AllArtistsPageState {
  final List<Artist> paginatedArtists;
  final int page;

  AllPaginatedArtistsLoadedState({
    required this.paginatedArtists,
    required this.page,
  });

  @override
  List<Object> get props => [paginatedArtists, page];
}

class AllPaginatedArtistsLoadingErrorState extends AllArtistsPageState {
  final String error;

  AllPaginatedArtistsLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
