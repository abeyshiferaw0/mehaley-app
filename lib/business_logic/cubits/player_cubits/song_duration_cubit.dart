import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';

class SongDurationCubit extends Cubit<Duration> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  SongDurationCubit({required this.audioPlayerBloc})
      : super(audioPlayerBloc.audioPlayer.duration != null
            ? audioPlayerBloc.audioPlayer.duration!
            : Duration.zero) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerDurationChangedState) {
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
