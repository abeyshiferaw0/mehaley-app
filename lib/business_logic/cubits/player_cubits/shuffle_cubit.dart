import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';

class ShuffleCubit extends Cubit<bool> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  ShuffleCubit({required this.audioPlayerBloc})
      : super(audioPlayerBloc.audioPlayer.shuffleModeEnabled) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerShuffleChangedState) {
        emit(state.isEnabled);
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
