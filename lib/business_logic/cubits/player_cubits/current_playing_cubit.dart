import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/song.dart';

class CurrentPlayingCubit extends Cubit<Song?> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  CurrentPlayingCubit({required this.audioPlayerBloc})
      : super(getInitialState(audioPlayerBloc)) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerCurrentSongChangeState) {
        emit(state.song);
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  static Song? getInitialState(audioPlayerBloc) {
    if (audioPlayerBloc.audioPlayer.sequenceState == null) {
      return null;
    } else {
      return Song.fromMap(
        (audioPlayerBloc.audioPlayer.sequenceState.currentSource.tag
                as MediaItem)
            .extras![AppValues.songExtraStr],
      );
    }
  }
}
