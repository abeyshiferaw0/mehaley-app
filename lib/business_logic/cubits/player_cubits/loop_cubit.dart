import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';

class LoopCubit extends Cubit<LoopMode> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  LoopCubit({required this.audioPlayerBloc})
      : super(audioPlayerBloc.audioPlayer.loopMode) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerLoopChangedState) {
        emit(state.loopMode);
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
