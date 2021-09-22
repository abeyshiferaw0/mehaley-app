part of 'playlist_page_bloc.dart';

@immutable
abstract class PlaylistPageState extends Equatable {}

class PlaylistPageInitial extends PlaylistPageState {
  @override
  List<Object?> get props => [];
}

class PlaylistPageLoadingState extends PlaylistPageState {
  @override
  List<Object?> get props => [];
}

class PlaylistPageLoadedState extends PlaylistPageState {
  final PlaylistPageData playlistPageData;

  PlaylistPageLoadedState({required this.playlistPageData});

  @override
  List<Object?> get props => [playlistPageData];
}

class PlaylistPageLoadingErrorState extends PlaylistPageState {
  final String error;

  PlaylistPageLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
