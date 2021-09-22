import 'package:bloc/bloc.dart';
import 'package:elf_play/config/constants.dart';

class PlayerPagePlayingFromCubit extends Cubit<PlayingFrom> {
  PlayerPagePlayingFromCubit() : super(PlayingFrom(from: "", title: ""));

  void changePlayingFrom(PlayingFrom playingFrom) {
    emit(playingFrom);
  }
}

class PlayingFrom {
  final String from;
  final String title;

  PlayingFrom({required this.from, required this.title});
}
