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
