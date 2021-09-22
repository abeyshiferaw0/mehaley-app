import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PlayerQueueCubit extends Cubit<QueueAndIndex> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  PlayerQueueCubit({required this.audioPlayerBloc})
      : super(getEffectiveSequence(audioPlayerBloc)) {
    subscription = audioPlayerBloc.stream.listen(
      (state) {
        if (state is AudioPlayerQueueChangedState) {
          emit(
            QueueAndIndex(queue: state.queue, currentIndex: state.currentIndex),
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  static QueueAndIndex getEffectiveSequence(AudioPlayerBloc audioPlayerBloc) {
    List<Song> queue = [];
    audioPlayerBloc.audioPlayer.sequenceState!.effectiveSequence.forEach(
      (mediaItem) {
        queue.add(
          Song.fromMap(
            (mediaItem.tag as MediaItem).extras![AppValues.songExtraStr],
          ),
        );
      },
    );

    return QueueAndIndex(
      queue: queue,
      currentIndex: audioPlayerBloc.audioPlayer.currentIndex != null
          ? audioPlayerBloc.audioPlayer.currentIndex!
          : 0,
    );
  }
}

class QueueAndIndex {
  final int currentIndex;
  final List<Song> queue;

  QueueAndIndex({required this.queue, required this.currentIndex});
}
