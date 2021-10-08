part of 'user_playlist_page_bloc.dart';

@immutable
abstract class UserPlaylistPageState extends Equatable {}

class UserPlaylistPageInitial extends UserPlaylistPageState {
  @override
  List<Object?> get props => [];
}

class UserPlaylistPageLoadingState extends UserPlaylistPageState {
  @override
  List<Object?> get props => [];
}

class UserPlaylistPageLoadedState extends UserPlaylistPageState {
  final UserPlaylistPageData userPlaylistPageData;

  UserPlaylistPageLoadedState({required this.userPlaylistPageData});

  @override
  List<Object?> get props => [userPlaylistPageData];
}

class UserPlaylistPageLoadingErrorState extends UserPlaylistPageState {
  final String error;

  UserPlaylistPageLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
