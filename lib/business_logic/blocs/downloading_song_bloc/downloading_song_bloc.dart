import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/repositories/setting_data_repository.dart';
import 'package:elf_play/util/download_util.dart';
import 'package:elf_play/util/network_util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

part 'downloading_song_event.dart';
part 'downloading_song_state.dart';

class DownloadingSongBloc
    extends Bloc<DownloadingSongEvent, DownloadingSongState> {
  DownloadingSongBloc({
    required this.settingDataRepository,
    required this.receivePort,
    required this.downloadUtil,
  }) : super(DownloadingSongInitial()) {
    ///INIT DOWNLOADER ISOLATE COMMUNICATION
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      AppValues.downloaderSendPort,
    );

    ///LISTEN TO DOWNLOADER ISOLATE
    receivePort.listen((dynamic data) {
      this.add(
        DownloadIngSongProgressEvent(
          taskId: data[0],
          downloadTaskStatus: data[1],
          progress: data[2],
        ),
      );
    });
    FlutterDownloader.registerCallback(DownloadUtil.downloadCallback);
  }

  ///DOWNLOAD UTIL
  final DownloadUtil downloadUtil;
  final ReceivePort receivePort;
  final SettingDataRepository settingDataRepository;

  @override
  Stream<DownloadingSongState> mapEventToState(
    DownloadingSongEvent event,
  ) async* {
    if (event is DownloadSongEvent) {
      ///GET SONG QUALITY FROM SETTING
      DownloadSongQuality downloadSongQuality =
          settingDataRepository.getDownloadQuality();

      ///CHEK IF DOWNLOAD ALREADY QUEUED
      bool isAlreadyInQueue = await downloadUtil.isAlreadyInQueue(event.song);

      ///CHECK IF INTERNET CONNECTION AVAILABLE
      bool isNetAvailable = await NetworkUtil.isInternetAvailable();
      if (isNetAvailable) {
        if (!isAlreadyInQueue) {
          String saveDir = await downloadUtil.getSaveDir(event.song);
          await FlutterDownloader.enqueue(
            url: downloadUtil.getDownloadUrl(
              event.song,
              downloadSongQuality,
            ),
            savedDir: saveDir,
            fileName: downloadUtil.getSongFileName(
              event.song,
              downloadSongQuality,
            ),
            notificationTitle: event.notificationTitle,
            showNotification: true,
            openFileFromNotification: false,
          );
        }
      } else {
        yield DownloadingSongInitial();
        yield SongDownloadedNetworkNotAvailableState();
      }
    } else if (event is RetryDownloadSongEvent) {
      ///GET FAILED TASK ID
      String? failedTaskId = await downloadUtil.getFailedTaskId(event.song);
      if (failedTaskId != null) {
        ///CHECK IF INTERNET CONNECTION AVAILABLE
        bool isNetAvailable = await NetworkUtil.isInternetAvailable();
        if (isNetAvailable) {
          await FlutterDownloader.retry(taskId: failedTaskId);
        } else {
          yield DownloadingSongInitial();
          yield SongDownloadedNetworkNotAvailableState();
        }
      } else {
        this.add(
          DownloadSongEvent(
            song: event.song,
            notificationTitle: event.notificationTitle,
          ),
        );
      }
    } else if (event is DownloadIngSongProgressEvent) {
      ///GET LIST OF DOWNLOADING SONGS
      if (event.downloadTaskStatus == DownloadTaskStatus.running) {
        Song? song = await downloadUtil.getSongFromTask(event.taskId);
        yield DownloadingSongsRunningState(
          downloadTaskStatus: event.downloadTaskStatus,
          progress: event.progress,
          taskId: event.taskId,
          song: song,
        );
      }
      if (event.downloadTaskStatus == DownloadTaskStatus.complete) {
        Song? song = await downloadUtil.getSongFromTask(event.taskId);
        yield DownloadingSongsCompletedState(
          downloadTaskStatus: event.downloadTaskStatus,
          progress: event.progress,
          taskId: event.taskId,
          song: song,
        );
      }
      if (event.downloadTaskStatus == DownloadTaskStatus.failed) {
        Song? song = await downloadUtil.getSongFromTask(event.taskId);
        yield DownloadingSongsFailedState(
          downloadTaskStatus: event.downloadTaskStatus,
          progress: event.progress,
          taskId: event.taskId,
          song: song,
        );
      }
    } else if (event is DeleteDownloadedSongEvent) {
      DownloadTask? downloadTask =
          await downloadUtil.getDownloadTask(event.song);

      if (downloadTask != null) {
        await FlutterDownloader.remove(
          taskId: downloadTask.taskId,
          shouldDeleteContent: true,
        );
      }

      yield DownloadingSongDeletedState(song: event.song);
    } else if (event is IsSongDownloadedEvent) {
      yield DownloadingSongInitial();

      DownloadTaskStatus downloadTaskStatus =
          await downloadUtil.isSongDownloadedCheckWithDb(event.song);
      yield SongIsDownloadedState(
        downloadTaskStatus: downloadTaskStatus,
        song: event.song,
      );
    }
  }

  @override
  Future<void> close() {
    IsolateNameServer.removePortNameMapping(AppValues.downloaderSendPort);
    return super.close();
  }
}
