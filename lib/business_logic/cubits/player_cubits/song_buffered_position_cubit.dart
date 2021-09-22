import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';

class SongBufferedCubit extends Cubit<Duration> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  SongBufferedCubit({required this.audioPlayerBloc})
      : super(audioPlayerBloc.audioPlayer.bufferedPosition) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerBufferedPositionChangedState) {
        emit(state.duration);
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
