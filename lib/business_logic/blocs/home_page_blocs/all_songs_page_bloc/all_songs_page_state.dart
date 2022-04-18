part of 'all_songs_page_bloc.dart';

abstract class AllSongsPageState extends Equatable {
  const AllSongsPageState();
}

class AllSongsPageInitial extends AllSongsPageState {
  @override
  List<Object> get props => [];
}

class AllPaginatedSongsLoadingState extends AllSongsPageState {
  @override
  List<Object> get props => [];
}

class AllPaginatedSongsLoadedState extends AllSongsPageState {
  final List<Song> paginatedSongs;
  final int page;

  AllPaginatedSongsLoadedState({
    required this.paginatedSongs,
    required this.page,
  });

  @override
  List<Object> get props => [paginatedSongs, page];
}

class AllPaginatedSongsLoadingErrorState extends AllSongsPageState {
  final String error;

  AllPaginatedSongsLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
