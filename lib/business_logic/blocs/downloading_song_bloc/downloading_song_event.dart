part of 'downloading_song_bloc.dart';

abstract class DownloadingSongEvent extends Equatable {
  const DownloadingSongEvent();
}

class DownloadSongEvent extends DownloadingSongEvent {
  final Song song;
  final String notificationTitle;

  DownloadSongEvent({
    required this.song,
    required this.notificationTitle,
  });

  @override
  List<Object?> get props => [song, notificationTitle];
}

class RetryDownloadSongEvent extends DownloadingSongEvent {
  final Song song;
  final String notificationTitle;

  RetryDownloadSongEvent({
    required this.song,
    required this.notificationTitle,
  });

  @override
  List<Object?> get props => [song, notificationTitle];
}

class DownloadIngSongProgressEvent extends DownloadingSongEvent {
  final DownloadTaskStatus downloadTaskStatus;
  final int progress;
  final String taskId;

  DownloadIngSongProgressEvent({
    required this.progress,
    required this.downloadTaskStatus,
    required this.taskId,
  });

  @override
  List<Object> get props => [downloadTaskStatus, progress, taskId];
}

class DeleteDownloadedSongEvent extends DownloadingSongEvent {
  final Song song;

  DeleteDownloadedSongEvent({
    required this.song,
  });

  @override
  List<Object?> get props => [song];
}

class IsSongDownloadedEvent extends DownloadingSongEvent {
  final Song song;

  IsSongDownloadedEvent({
    required this.song,
  });

  @override
  List<Object?> get props => [song];
}
