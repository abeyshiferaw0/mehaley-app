import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/api_response/settings_page_data.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/repositories/setting_data_repository.dart';
import 'package:elf_play/util/download_util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

part 'downloading_song_event.dart';
part 'downloading_song_state.dart';

class DownloadingSongBloc
    extends Bloc<DownloadingSongEvent, DownloadingSongState> {
  DownloadingSongBloc(
      {required this.settingDataRepository,
      required this.receivePort,
      required this.downloadUtil})
      : super(DownloadingSongInitial()) {
    ///INIT DOWNLOADER ISOLATE COMMUNICATION
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      AppValues.downloaderSendPort,
    );

    ///LISTEN TO DOWNLOADER ISOLATE
    receivePort.listen((dynamic data) {
      print("datadatadata=> ${data}");
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
      SettingsPageData settingsPageData =
          await settingDataRepository.getSettingsPageData();
      bool isAlreadyInQueue = await downloadUtil.isAlreadyInQueue(event.song);
      if (!isAlreadyInQueue) {
        String saveDir = await downloadUtil.getSaveDir(event.song);
        await FlutterDownloader.enqueue(
          url: downloadUtil.getDownloadUrl(
            event.song,
            settingsPageData.downloadSongQuality,
          ),
          savedDir: saveDir,
          fileName: downloadUtil.getSongFileName(
            event.song,
            settingsPageData.downloadSongQuality,
          ),
          showNotification: true,
          openFileFromNotification: false,
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
      DownloadTaskStatus downloadTaskStatus =
          await downloadUtil.isSongDownloaded(event.song);
      yield DownloadingSongInitial();
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
