import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:just_audio/just_audio.dart';

class IsMutedCubit extends Cubit<bool> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  IsMutedCubit({required this.audioPlayerBloc}) : super(false) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerVolumeChangedState) {
        if (state.volume == 0.0) {
          emit(true);
        } else {
          emit(false);
        }
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
