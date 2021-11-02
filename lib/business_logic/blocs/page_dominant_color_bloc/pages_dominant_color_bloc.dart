import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meta/meta.dart';

part 'pages_dominant_color_event.dart';
part 'pages_dominant_color_state.dart';

class PagesDominantColorBloc
    extends Bloc<PagesDominantColorEvent, PagesDominantColorState> {
  PagesDominantColorBloc({required this.audioPlayerBloc})
      : super(PagesDominantColorInitial()) {
    audioPlayerBloc.stream.listen(
      (state) async {
        if (state is AudioPlayerCurrentSongChangeState) {
          this.add(
            PlayerPageDominantColorChanged(
              dominantColor: state.song.albumArt.primaryColorHex,
            ),
          );
        }
      },
    );
  }

  late StreamSubscription subscription;
  final AudioPlayerBloc audioPlayerBloc;

  @override
  Stream<PagesDominantColorState> mapEventToState(
    PagesDominantColorEvent event,
  ) async* {
    if (event is AlbumPageDominantColorChanged) {
      Color dominantColor = ColorUtil.darken(
        HexColor(event.dominantColor),
        0.15,
      );
      yield AlbumPageDominantColorChangedState(color: dominantColor);
    } else if (event is PlaylistPageDominantColorChanged) {
      Color dominantColor = ColorUtil.darken(
        HexColor(event.dominantColor),
        0.15,
      );
      yield PlaylistPageDominantColorChangedState(color: dominantColor);
    } else if (event is PlayerPageDominantColorChanged) {
      Color dominantColor = ColorUtil.darken(
        HexColor(event.dominantColor),
        0.15,
      );
      yield PlayerPageDominantColorChangedState(color: dominantColor);
    } else if (event is UserPlaylistPageDominantColorChanged) {
      Color dominantColor = ColorUtil.darken(
        event.dominantColor,
        0.15,
      );
      yield UserPlaylistPageDominantColorChangedState(color: dominantColor);
    } else if (event is UserProfilePageDominantColorChanged) {
      Color dominantColor = ColorUtil.darken(
        event.dominantColor,
        0.0,
      );
      yield ProfilePageDominantColorChangedState(color: dominantColor);
    } else if (event is HomePageDominantColorChanged) {
      Color dominantColor = ColorUtil.darken(
        event.dominantColor,
        0.0,
      );
      yield HomePageDominantColorChangedState(color: dominantColor);
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
