import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:equatable/equatable.dart';

part 'sync_song_event.dart';
part 'sync_song_state.dart';

class SyncSongBloc extends Bloc<SyncSongEvent, SyncSongState> {
  final AudioPlayerBloc audioPlayerBloc;
  late StreamSubscription streamSubscription;

  SyncSongBloc({required this.audioPlayerBloc}) : super(SyncSongInitial()) {
    initSongSync();
  }

  @override
  Stream<SyncSongState> mapEventToState(
    SyncSongEvent event,
  ) async* {
    if (event is DumSongEvent) {
      yield SyncSongDumState();
    }
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  void initSongSync() async {
    streamSubscription = audioPlayerBloc.stream.listen((state) {
      print(
          "//////////////////// audioPlayerBlocaudioPlayerBloc ////////////////////");
      if (state is AudioPlayerPositionChangedState) {
        print(
            "//////////////////// AudioPlayerPositionChangedState ////////////////////");
        if (state.songSync != null) {
          print(
              "//////////////////// AudioPlayerPositionChangedState ////////////////////");
          print(
              "AudioPlayerDurationChangedState => SONG_SYNC => ${state.songSync!.toMap()}");
          print(
              "//////////////////// AudioPlayerPositionChangedState ////////////////////");
        }
      }
    });
    print("initSongSyncinitSongSync");
  }
}
