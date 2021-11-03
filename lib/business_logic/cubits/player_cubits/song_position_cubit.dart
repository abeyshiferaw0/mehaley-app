import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/sync/song_sync.dart';
import 'package:just_audio_background/just_audio_background.dart';

class SongPositionCubit extends Cubit<CurrentPlayingPosition> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  SongPositionCubit({required this.audioPlayerBloc})
      : super(
          CurrentPlayingPosition(
            songSync: null,
            currentDuration: audioPlayerBloc.audioPlayer.position,
            previousDuration: audioPlayerBloc.audioPlayer.position,
          ),
        ) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerPositionChangedState) {
        print(
            "SongPositionCubitttt=>  PRE=> ${this.state.currentDuration.toString()}  CUR=> ${state.duration.toString()}");
        emit(
          CurrentPlayingPosition(
            songSync: getCurrentPlayingSongSyncData(),
            currentDuration: state.duration,
            previousDuration: this.state.currentDuration,
          ),
        );
      }
    });
  }

  SongSync? getCurrentPlayingSongSyncData() {
    if (audioPlayerBloc.audioPlayer.sequenceState == null) return null;
    final currentItem =
        audioPlayerBloc.audioPlayer.sequenceState!.currentSource;
    MediaItem mediaItem = (currentItem!.tag as MediaItem);
    SongSync songSync = SongSync.fromMap(
      mediaItem.extras![AppValues.songSyncExtraStr],
    );
    return songSync;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}

class CurrentPlayingPosition {
  final Duration previousDuration;
  final Duration currentDuration;
  final SongSync? songSync;

  CurrentPlayingPosition({
    required this.previousDuration,
    required this.currentDuration,
    required this.songSync,
  });
}
