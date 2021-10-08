part of 'user_playlist_bloc.dart';

abstract class UserPlaylistEvent extends Equatable {
  const UserPlaylistEvent();
}

class PostUserPlaylistEvent extends UserPlaylistEvent {
  final String playlistName;
  final String playlistDescription;
  final File playlistImage;
  final bool createWithSong;
  final Song? song;

  PostUserPlaylistEvent({
    required this.createWithSong,
    required this.song,
    required this.playlistName,
    required this.playlistDescription,
    required this.playlistImage,
  });

  @override
  List<Object?> get props => [
        playlistName,
        playlistDescription,
        playlistImage,
        createWithSong,
        song,
      ];
}

class UpdateUserPlaylistEvent extends UserPlaylistEvent {
  final String playlistName;
  final String playlistDescription;
  final File playlistImage;
  final int playlistId;
  final bool imageRemoved;

  UpdateUserPlaylistEvent({
    required this.playlistName,
    required this.playlistDescription,
    required this.playlistImage,
    required this.playlistId,
    required this.imageRemoved,
  });

  @override
  List<Object?> get props => [
        playlistName,
        playlistDescription,
        playlistImage,
        playlistId,
        imageRemoved,
      ];
}

class AddSongUserPlaylistEvent extends UserPlaylistEvent {
  final MyPlaylist myPlaylist;
  final Song song;

  AddSongUserPlaylistEvent({
    required this.song,
    required this.myPlaylist,
  });

  @override
  List<Object?> get props => [myPlaylist, song];
}

class RemoveSongUserPlaylistEvent extends UserPlaylistEvent {
  final MyPlaylist myPlaylist;
  final Song song;

  RemoveSongUserPlaylistEvent({
    required this.song,
    required this.myPlaylist,
  });

  @override
  List<Object?> get props => [myPlaylist, song];
}
