part of 'playlist_page_bloc.dart';

@immutable
abstract class PlaylistPageEvent extends Equatable {}

class LoadPlaylistPageEvent extends PlaylistPageEvent {
  final int playlistId;

  LoadPlaylistPageEvent({required this.playlistId});

  @override
  List<Object?> get props => [playlistId];
}
