import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/data/models/sync/song_sync.dart';
import 'package:elf_play/data/repositories/sync_repository.dart';
import 'package:equatable/equatable.dart';

part 'song_listen_recorder_event.dart';
part 'song_listen_recorder_state.dart';

class SongListenRecorderBloc
    extends Bloc<SongListenRecorderEvent, SongListenRecorderState> {
  final AudioPlayerBloc audioPlayerBloc;
  final SyncRepository syncRepository;
  late StreamSubscription streamSubscription;

  SongListenRecorderBloc(
      {required this.syncRepository, required this.audioPlayerBloc})
      : super(SongListenRecorderInitial()) {
    ///LISTEN FOR AUDIO POSITION CHANGE AND RECORD
    streamSubscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerPositionChangedState) {
        if (state.songSync != null) {
          ///SAVE SONG SYNC OBJECT IN HIVE FOR LATER SYNCING
          this.add(
            SaveRecordedSongEvent(songSync: state.songSync!),
          );
        }
      }
      if (state is AudioPlayerSkipChangedState) {
        if (state.songSync != null) {
          this.add(
            SaveRecordedSongEvent(
              songSync: state.songSync!,
              previousDuration: state.previousDuration,
              skipToDuration: state.skipToDuration,
            ),
          );
        }
      }
    });
  }

  @override
  Stream<SongListenRecorderState> mapEventToState(
    SongListenRecorderEvent event,
  ) async* {
    if (event is StartRecordEvent) {
      yield SongRecordingStartedState();
    } else if (event is SaveRecordedSongEvent) {
      yield RecordedSongSavingState(songSync: event.songSync);
      SongSync songSync=event.songSync;
      try {
        if(event.skipToDuration!=null&&event.previousDuration!=null){

          songSync = event.songSync.copyWith(secondsPlayed: songSync)
        }
        syncRepository.saveSyncData(songSync);
        yield RecordedSongSuccessState(
          songSync: event.songSync,
        );
      } catch (e) {
        yield RecordedSongErrorState(
          error: e.toString(),
        );
      }
    }
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
