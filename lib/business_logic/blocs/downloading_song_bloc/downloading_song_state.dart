part of 'downloading_song_bloc.dart';

abstract class DownloadingSongState extends Equatable {
  const DownloadingSongState();
}

class DownloadingSongInitial extends DownloadingSongState {
  @override
  List<Object> get props => [];
}

// class DownloadingSongProgressState extends DownloadingSongState {
//   final DownloadTaskStatus downloadTaskStatus;
//   final int progressPercentage;
//   final int songId;
//
//   DownloadingSongProgressState({
//     required this.downloadTaskStatus,
//     required this.progressPercentage,
//     required this.songId,
//   });
//
//   @override
//   List<Object> get props => [downloadTaskStatus];
// }

class DownloadingSongsRunningState extends DownloadingSongState {
  final DownloadTaskStatus downloadTaskStatus;
  final int progress;
  final String taskId;
  final Song? song;

  DownloadingSongsRunningState({
    required this.song,
    required this.downloadTaskStatus,
    required this.progress,
    required this.taskId,
  });

  @override
  List<Object> get props => [downloadTaskStatus, progress, taskId];
}

class DownloadingSongsCompletedState extends DownloadingSongState {
  final DownloadTaskStatus downloadTaskStatus;
  final int progress;
  final String taskId;
  final Song? song;

  DownloadingSongsCompletedState({
    required this.downloadTaskStatus,
    required this.progress,
    required this.taskId,
    required this.song,
  });

  @override
  List<Object> get props => [downloadTaskStatus, progress, taskId];
}

class DownloadingSongsFailedState extends DownloadingSongState {
  final DownloadTaskStatus downloadTaskStatus;
  final int progress;
  final String taskId;
  final Song? song;

  DownloadingSongsFailedState({
    required this.downloadTaskStatus,
    required this.progress,
    required this.song,
    required this.taskId,
  });

  @override
  List<Object> get props => [downloadTaskStatus, progress, taskId];
}

class DownloadingSongDeletedState extends DownloadingSongState {
  final Song song;

  DownloadingSongDeletedState({
    required this.song,
  });

  @override
  List<Object> get props => [song];
}

class SongIsDownloadedState extends DownloadingSongState {
  final DownloadTaskStatus downloadTaskStatus;
  final Song song;

  SongIsDownloadedState({required this.song, required this.downloadTaskStatus});
  @override
  List<Object?> get props => [downloadTaskStatus, song];
}

class SongDownloadedNetworkNotAvailableState extends DownloadingSongState {
  @override
  List<Object?> get props => [];
}

class SongDownloadedPhoneRootedState extends DownloadingSongState {
  @override
  List<Object?> get props => [];
}
