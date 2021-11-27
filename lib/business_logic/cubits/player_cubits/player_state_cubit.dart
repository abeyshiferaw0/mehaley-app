import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';

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
