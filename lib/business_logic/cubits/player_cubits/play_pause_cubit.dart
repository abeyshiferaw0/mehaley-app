import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';

class PlayPauseCubit extends Cubit<bool> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  PlayPauseCubit({required this.audioPlayerBloc})
      : super(audioPlayerBloc.audioPlayer.playing) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerPlayPauseStateChangedState) {
        emit(state.isPlaying);
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
