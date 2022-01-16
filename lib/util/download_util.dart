import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:path_provider/path_provider.dart';

class DownloadUtil {
  getDownloadUrl(
    Song song,
    DownloadSongQuality downloadSongQuality,
  ) {
    ///IS USER SUBSCRIBED
    final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();

    String downloadPath = '';
    if (downloadSongQuality == DownloadSongQuality.LOW_QUALITY) {
      downloadPath = song.audioFile.audioSmallPath;
    }
    if (downloadSongQuality == DownloadSongQuality.MEDIUM_QUALITY) {
      downloadPath = song.audioFile.audioMediumPath;
    }
    if (downloadSongQuality == DownloadSongQuality.HIGH_QUALITY) {
      downloadPath = song.audioFile.audioLargePath;
    }
    return '$downloadPath?val=${Song.toBase64Str(song)}&val=${isUserSubscribed ? '1' : '0'}';
  }

  getSongFileName(Song song) {
    return 'SONG_${song.songId}.mp3';
  }

  Future<String> getSaveDir(Song song) async {
    Directory directory = await getApplicationSupportDirectory();
    Directory saveDir = Directory(
      '${directory.absolute.path}${Platform.pathSeparator}${AppValues.folderMedia}${Platform.pathSeparator}${AppValues.folderSongs}${Platform.pathSeparator}',
    );
    bool exists = await saveDir.exists();
    if (!exists) {
      await saveDir.create(recursive: true);
    }
    return saveDir.path;
  }

  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    final SendPort? send = IsolateNameServer.lookupPortByName(
      AppValues.downloaderSendPort,
    );
    send!.send([id, status, progress]);
  }

  Future<List<Song>> getDownloadingSongFromString() async {
    ///GET RUNNING DOWNLOADS
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query:
          'SELECT * FROM task WHERE status=${DownloadTaskStatus.running.value} OR status=${DownloadTaskStatus.enqueued.value}',
    );

    List<Song> songs = [];
    if (tasks != null) {
      if (tasks.length > 0) {
        tasks.forEach((element) {
          songs.add(Song.fromBase64(getSongPortion(element.url)));
        });
        return songs;
      }
    }
    return [];
  }

  Future<List<Song>> getFailedSongFromString() async {
    ///GET FAILED DOWNLOADS
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query:
          'SELECT * FROM task WHERE status=${DownloadTaskStatus.failed.value}',
    );

    List<Song> songs = [];
    if (tasks != null) {
      if (tasks.length > 0) {
        tasks.forEach((element) {
          songs.add(Song.fromBase64(getSongPortion(element.url)));
        });
        return songs;
      }
    }
    return [];
  }

  Future<Song?> getSongFromTask(String taskId) async {
    ///GET RUNNING DOWNLOADS
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE task_id='$taskId'",
    );

    if (tasks != null) {
      if (tasks.length > 0) {
        return Song.fromBase64(getSongPortion(tasks.first.url));
      }
    }
    return null;
  }

  DownloadedTaskWithSong? isSongDownloaded(
      Song song, List<DownloadedTaskWithSong> allDownloads) {
    for (var i = 0; i < allDownloads.length; i++) {
      if (allDownloads[i].song.songId == song.songId) {
        return allDownloads[i];
      }
    }
    return null;
  }

  Future<DownloadTaskStatus> isSongDownloadedCheckWithDb(Song song) async {
    ///GET LIST OF COMPLETED DOWNLOADS
    final String fileName = getSongFileName(song);
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE file_name='$fileName'",
    );

    if (tasks == null) return DownloadTaskStatus.undefined;
    if (tasks.length < 1) return DownloadTaskStatus.undefined;

    if (Song.fromBase64(getSongPortion(tasks.first.url)) == song) {
      return tasks.first.status;
    }
    return DownloadTaskStatus.undefined;
  }

  Future<DownloadTask?> getSongDownloadTask(Song song) async {
    ///GET LIST OF COMPLETED DOWNLOADS
    final String fileName = getSongFileName(song);
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE file_name='$fileName'",
    );

    if (tasks != null) {
      if (tasks.length > 0) {
        return tasks.first;
      }
    }
    return null;
  }

  Future<DownloadTask?> isSongDownloadedForPlayback(Song song) async {
    ///GET LIST OF COMPLETED DOWNLOADS
    final String fileName = getSongFileName(song);
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE file_name='$fileName'",
    );

    if (tasks == null) return null;
    if (tasks.length < 1) return null;

    if (Song.fromBase64(getSongPortion(tasks.first.url)) == song) {
      return tasks.first;
    }
    return null;
  }

  Future<List<DownloadedTaskWithSong>> getAllDownloadedSongs() async {
    ///GET LIST OF COMPLETED DOWNLOADS
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query:
          'SELECT * FROM task WHERE status=${DownloadTaskStatus.complete.value}',
    );

    List<DownloadedTaskWithSong> downloadedTaskWithSongs = [];

    if (tasks == null) return [];
    if (tasks.length < 1) return [];

    tasks.forEach((e) {
      downloadedTaskWithSongs.add(
        DownloadedTaskWithSong(
          task: e,
          song: Song.fromBase64(getSongPortion(e.url)),
        ),
      );
    });

    return downloadedTaskWithSongs;
  }

  Future<DownloadTask?> getDownloadTask(Song song) async {
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query:
          'SELECT * FROM task WHERE status=${DownloadTaskStatus.complete.value}',
    );
    if (tasks == null) return null;
    if (tasks.length < 1) return null;

    return tasks.firstWhere((element) {
      if (Song.fromBase64(getSongPortion(element.url)).songId == song.songId) {
        return true;
      }
      return false;
    });
  }

  Future<List<DownloadTask>?> getAllDownloadTasks() async {
    final List<DownloadTask>? tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query:
            'SELECT * FROM task WHERE status=${DownloadTaskStatus.complete.value}');
    if (tasks == null) return null;
    if (tasks.length < 1) return null;

    return tasks;
  }

  Future<bool> isAlreadyInQueue(Song song) async {
    ///GET LIST OF COMPLETED DOWNLOADS
    final String fileName = getSongFileName(song);
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE file_name='$fileName'",
    );

    if (tasks == null) return false;
    if (tasks.length < 1) return false;

    if (Song.fromBase64(getSongPortion(tasks.first.url)) == song) {
      return true;
    }
    return false;
  }

  Future<String?> getFailedTaskId(Song song) async {
    ///GET LIST OF COMPLETED DOWNLOADS
    final String fileName = getSongFileName(song);
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE file_name='$fileName'",
    );

    if (tasks == null) return null;
    if (tasks.length < 1) return null;

    if (Song.fromBase64(getSongPortion(tasks.first.url)) == song) {
      return tasks.first.taskId;
    }
    return null;
  }

  Future<int> getNumberOfDownloads() async {
    final List<DownloadTask>? tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query:
            'SELECT * FROM task WHERE status=${DownloadTaskStatus.complete.value}');
    if (tasks == null) return 0;
    return tasks.length;
  }

  static String getSongPortion(String url) {
    String str = url.split('val=')[1];

    return str.substring(0, str.length - 1);
  }

  static String getIsUserSubscribedPortion(String url) {
    return url.split('val=')[2];
  }
}

class DownloadedTaskWithSong {
  final DownloadTask task;
  final Song song;

  DownloadedTaskWithSong({required this.task, required this.song});
}
