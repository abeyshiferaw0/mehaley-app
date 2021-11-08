import 'package:bloc/bloc.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';

class PlayerPagePlayingFromCubit extends Cubit<PlayingFrom> {
  PlayerPagePlayingFromCubit()
      : super(PlayingFrom(
          from: '',
          title: '',
          songSyncPlayedFrom: SongSyncPlayedFrom.UNK,
          songSyncPlayedFromId: -1,
        ));

  void changePlayingFrom(PlayingFrom playingFrom) {
    emit(playingFrom);
  }
}

class PlayingFrom {
  final String from;
  final String title;
  final SongSyncPlayedFrom songSyncPlayedFrom;
  final int songSyncPlayedFromId;

  PlayingFrom({
    required this.songSyncPlayedFrom,
    required this.songSyncPlayedFromId,
    required this.from,
    required this.title,
  });
}
