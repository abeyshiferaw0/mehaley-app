part of 'my_playlist_bloc.dart';

abstract class MyPlaylistState extends Equatable {
  const MyPlaylistState();
}

class MyPlaylistInitial extends MyPlaylistState {
  @override
  List<Object> get props => [];
}

class MyPlaylistLoadingState extends MyPlaylistState {
  @override
  List<Object?> get props => [];
}

class MyPlaylistRefreshLoadingState extends MyPlaylistState {
  @override
  List<Object?> get props => [];
}

class MyPlaylistLoadingErrorState extends MyPlaylistState {
  final String error;

  MyPlaylistLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class MyPlaylistPageDataLoaded extends MyPlaylistState {
  final MyPlaylistPageData myPlaylistPageData;

  MyPlaylistPageDataLoaded({required this.myPlaylistPageData});

  @override
  List<Object?> get props => [myPlaylistPageData];
}
