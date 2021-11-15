import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/sync/song_sync.dart';
import 'package:mehaley/data/repositories/sync_repository.dart';

part 'song_sync_event.dart';
part 'song_sync_state.dart';

class SongSyncBloc extends Bloc<SongSyncEvent, SongSyncState> {
  final SyncRepository syncRepository;
  late Timer timer;

  SongSyncBloc({required this.syncRepository}) : super(SongSyncInitial()) {
    timer = Timer.periodic(
      Duration(seconds: AppValues.songSyncTimerGapInSeconds),
      (Timer t) {
        if (!(state is SyncingState)) {
          ///IF NOT CURRENTLY SYNCING, SYNC
          this.add(
            SyncEvent(hCode: t.hashCode),
          );
        }
      },
    );
  }

  @override
  Stream<SongSyncState> mapEventToState(SongSyncEvent event) async* {
    if (event is StartSongSyncEvent) {
      yield SongSyncingStartedEvent();
    } else if (event is SyncEvent) {
      yield SyncingState();
      try {
        List<SongSync> songSyncList = syncRepository.getSongsToSync();
        if (songSyncList.length > 0) {
          await syncRepository.syncSongs(songSyncList);
        }
        yield SyncingSuccessState();
      } catch (e) {
        SyncingErrorState(error: e.toString());
      }
    }
  }

  @override
  Future<void> close() {
    timer.cancel();
    return super.close();
  }
}
