import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PlayerStateCubit extends Cubit<PlayerState> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  PlayerStateCubit({required this.audioPlayerBloc})
      : super(PlayerState(false, ProcessingState.idle)) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerStateChangedState) {
        emit(state.playerState);
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
