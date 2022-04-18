part of 'all_albums_page_bloc.dart';

abstract class AllAlbumsPageState extends Equatable {
  const AllAlbumsPageState();
}

class AllAlbumsPageInitial extends AllAlbumsPageState {
  @override
  List<Object> get props => [];
}

class AllPaginatedAlbumsLoadingState extends AllAlbumsPageState {
  @override
  List<Object> get props => [];
}

class AllPaginatedAlbumsLoadedState extends AllAlbumsPageState {
  final List<Album> paginatedAlbums;
  final int page;

  AllPaginatedAlbumsLoadedState({
    required this.paginatedAlbums,
    required this.page,
  });

  @override
  List<Object> get props => [paginatedAlbums, page];
}

class AllPaginatedAlbumsLoadingErrorState extends AllAlbumsPageState {
  final String error;

  AllPaginatedAlbumsLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
