part of 'playlist_page_bloc.dart';

@immutable
abstract class PlaylistPageEvent extends Equatable {}

class LoadPlaylistPageEvent extends PlaylistPageEvent {
  final int playlistId;

  LoadPlaylistPageEvent({required this.playlistId});

  @override
  List<Object?> get props => [playlistId];
}

class LoadPaginatedPlaylistPageEvent extends PlaylistPageEvent {
  final int playlistId;
  final int page;

  LoadPaginatedPlaylistPageEvent({required this.playlistId,required this.page});

  @override
  List<Object?> get props => [playlistId,page];
}
