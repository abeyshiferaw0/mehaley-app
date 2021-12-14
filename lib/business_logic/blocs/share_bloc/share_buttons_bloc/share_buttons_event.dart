part of 'share_buttons_bloc.dart';

abstract class ShareButtonsEvent extends Equatable {
  const ShareButtonsEvent();
}

class ShareLyricEvent extends ShareButtonsEvent {
  ShareLyricEvent({
    required this.lyricScreenShotFile,
    required this.song,
  });

  final Uint8List? lyricScreenShotFile;
  final Song song;

  @override
  List<Object?> get props => [lyricScreenShotFile, song];
}

class ShareSongEvent extends ShareButtonsEvent {
  ShareSongEvent({
    required this.song,
  });

  final Song song;

  @override
  List<Object?> get props => [song];
}

class ShareArtistEvent extends ShareButtonsEvent {
  ShareArtistEvent({
    required this.artist,
  });

  final Artist artist;

  @override
  List<Object?> get props => [artist];
}

class SharePlaylistEvent extends ShareButtonsEvent {
  SharePlaylistEvent({
    required this.playlist,
  });

  final Playlist playlist;

  @override
  List<Object?> get props => [playlist];
}

class ShareAlbumEvent extends ShareButtonsEvent {
  ShareAlbumEvent({
    required this.album,
  });

  final Album album;

  @override
  List<Object?> get props => [album];
}
