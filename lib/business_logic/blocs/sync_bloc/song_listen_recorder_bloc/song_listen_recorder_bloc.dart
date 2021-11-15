import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:mehaley/data/models/sync/song_sync.dart';
import 'package:mehaley/data/repositories/sync_repository.dart';

part 'song_listen_recorder_event.dart';
part 'song_listen_recorder_state.dart';

class SongListenRecorderBloc
    extends Bloc<SongListenRecorderEvent, SongListenRecorderState> {
  final SongPositionCubit songPositionCubit;
  final SyncRepository syncRepository;
  late StreamSubscription streamSubscription;

  SongListenRecorderBloc(
      {required this.syncRepository, required this.songPositionCubit})
      : super(SongListenRecorderInitial()) {
    ///LISTEN FOR AUDIO POSITION CHANGE AND RECORD
    streamSubscription = songPositionCubit.stream.listen((state) {
      if (state.songSync != null) {
        ///SAVE SONG SYNC OBJECT IN HIVE FOR LATER SYNCING
        ///MAKE SURE SKIP SECONDS ARE NOT USED
        if (state.currentDuration.inSeconds - state.previousDuration.inSeconds >
                0 &&
            state.currentDuration.inSeconds - state.previousDuration.inSeconds <
                2) {
          this.add(SaveRecordedSongEvent(
            songSync: state.songSync!,
            previousDuration: state.previousDuration,
            currentDuration: state.currentDuration,
          ));
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
      SongSync songSync = event.songSync;
      try {
        syncRepository.saveSyncData(
          songSync,
          event.currentDuration,
          event.previousDuration,
        );
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
