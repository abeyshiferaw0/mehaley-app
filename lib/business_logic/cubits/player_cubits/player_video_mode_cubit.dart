import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';

class PlayerVideoModeCubit extends Cubit<bool> {
  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  PlayerVideoModeCubit({required this.audioPlayerBloc}) : super(false) {
    subscription = audioPlayerBloc.stream.listen((state) {
      if (state is AudioPlayerVideoModeChangedState) {
        emit(state.enabled);
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
