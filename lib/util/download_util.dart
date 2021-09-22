import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadUtil {
  getDownloadUrl(
    Song song,
    DownloadSongQuality downloadSongQuality,
  ) {
    String downloadPath = "";
    if (downloadSongQuality == DownloadSongQuality.LOW_QUALITY) {
      downloadPath = song.audioFile.audioSmallPath;
    }
    if (downloadSongQuality == DownloadSongQuality.MEDIUM_QUALITY) {
      downloadPath = song.audioFile.audioMediumPath;
    }
    if (downloadSongQuality == DownloadSongQuality.HIGH_QUALITY) {
      downloadPath = song.audioFile.audioLargePath;
    }
    print(
        "DOWNLOADINGGG URL => ${AppApi.baseFileUrl}$downloadPath?song=${Song.toBase64Str(song)}");
    //return "${AppApi.baseFileUrl}$downloadPath?song=${songJsonToStr(song)}";
    return "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_5MG.mp3?song=${Song.toBase64Str(song)}";
  }

  getSongFileName(
    Song song,
    DownloadSongQuality appDownloadQualityOptions,
  ) {
    return "SONG_${EnumToString.convertToString(appDownloadQualityOptions)}_${song.songId}.mp3";
  }

  Future<String> getSaveDir(Song song) async {
    Directory directory = await getApplicationSupportDirectory();
    Directory saveDir = Directory(
        "${directory.absolute.path}${Platform.pathSeparator}${AppValues.folderMedia}${Platform.pathSeparator}${AppValues.folderSongs}${Platform.pathSeparator}");
    bool exists = await saveDir.exists();
    if (!exists) {
      await saveDir.create(recursive: true);
    }
    exists = await saveDir.exists();
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
          "SELECT * FROM task WHERE status=${DownloadTaskStatus.running.value} OR status=${DownloadTaskStatus.enqueued.value}",
    );

    List<Song> songs = [];
    if (tasks != null) {
      if (tasks.length > 0) {
        tasks.forEach((element) {
          songs.add(Song.fromBase64(element.url.split("?song=")[1]));
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
          "SELECT * FROM task WHERE status=${DownloadTaskStatus.failed.value}",
    );

    List<Song> songs = [];
    if (tasks != null) {
      if (tasks.length > 0) {
        tasks.forEach((element) {
          songs.add(Song.fromBase64(element.url.split("?song=")[1]));
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
        return Song.fromBase64(tasks.first.url.split("?song=")[1]);
      }
    }
    return null;
  }

  Future<DownloadTaskStatus> isSongDownloaded(Song song) async {
    ///GET LIST OF COMPLETED DOWNLOADS
    //return "${AppApi.baseFileUrl}$downloadPath?song=${songJsonToStr(song)}";
    final String url =
        "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_5MG.mp3?song=${Song.toBase64Str(song)}";
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE url='$url'",
    );

    if (tasks == null) return DownloadTaskStatus.undefined;
    if (tasks.length < 1) return DownloadTaskStatus.undefined;

    if (Song.fromBase64(tasks.first.url.split("?song=")[1]) == song) {
      return tasks.first.status;
    }
    return DownloadTaskStatus.undefined;
  }

  Future<DownloadTask?> isSongDownloadedForPlayback(Song song) async {
    ///GET LIST OF COMPLETED DOWNLOADS
    //return "${AppApi.baseFileUrl}$downloadPath?song=${songJsonToStr(song)}";
    final String url =
        "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_5MG.mp3?song=${Song.toBase64Str(song)}";
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE url='$url'",
    );

    if (tasks == null) return null;
    if (tasks.length < 1) return null;

    if (Song.fromBase64(tasks.first.url.split("?song=")[1]) == song) {
      return tasks.first;
    }
    return null;
  }

  Future<List<Song>> getAllDownloadedSongs() async {
    ///GET LIST OF COMPLETED DOWNLOADS
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query:
          "SELECT * FROM task WHERE status=${DownloadTaskStatus.complete.value}",
    );
    if (tasks == null) return [];
    if (tasks.length < 1) return [];

    List<Song> completedSongs = tasks.map<Song>((e) {
      return Song.fromBase64(e.url.split("?song=")[1]);
    }).toList();
    return completedSongs;
  }

  Future<DownloadTask?> getDownloadTask(Song song) async {
    final List<DownloadTask>? tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query:
            "SELECT * FROM task WHERE status=${DownloadTaskStatus.complete.value}");
    if (tasks == null) return null;
    if (tasks.length < 1) return null;

    return tasks.firstWhere((element) {
      if (Song.fromBase64(element.url.split("?song=")[1]).songId ==
          song.songId) {
        return true;
      }
      return false;
    });
  }

  Future<List<DownloadTask>?> getAllDownloadTasks() async {
    final List<DownloadTask>? tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query:
            "SELECT * FROM task WHERE status=${DownloadTaskStatus.complete.value}");
    if (tasks == null) return null;
    if (tasks.length < 1) return null;

    return tasks;
  }

  Future<bool> isAlreadyInQueue(Song song) async {
    ///GET LIST OF COMPLETED DOWNLOADS
    //return "${AppApi.baseFileUrl}$downloadPath?song=${songJsonToStr(song)}";
    final String url =
        "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_5MG.mp3?song=${Song.toBase64Str(song)}";
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE url='$url'",
    );

    if (tasks == null) return false;
    if (tasks.length < 1) return false;

    if (Song.fromBase64(tasks.first.url.split("?song=")[1]) == song) {
      return true;
    }
    return false;
  }
}
