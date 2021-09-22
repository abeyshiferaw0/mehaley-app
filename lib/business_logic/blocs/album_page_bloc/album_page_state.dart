part of 'album_page_bloc.dart';

@immutable
abstract class AlbumPageState extends Equatable {}

class AlbumPageInitial extends AlbumPageState {
  @override
  List<Object?> get props => [];
}

class AlbumPageLoadingState extends AlbumPageState {
  @override
  List<Object?> get props => [];
}

class AlbumPageLoadedState extends AlbumPageState {
  final AlbumPageData albumPageData;

  AlbumPageLoadedState({required this.albumPageData});

  @override
  List<Object?> get props => [albumPageData];
}

class AlbumPageLoadingErrorState extends AlbumPageState {
  final String error;

  AlbumPageLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
