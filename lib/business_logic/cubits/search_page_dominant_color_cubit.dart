import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchPageDominantColorCubit extends Cubit<Color> {
  final SearchResultBloc searchResultBloc;
  late StreamSubscription streamSubscription;

  SearchPageDominantColorCubit({required this.searchResultBloc})
      : super(AppColors.appGradientDefaultColorBlack) {
    streamSubscription = searchResultBloc.stream.listen(
      (state) {
        if (state is SearchResultPageLoadedState) {
          if (state.searchPageResultData.topArtistData.topArtist != null) {
            changePlayingFrom(state.searchPageResultData.topArtistData
                .topArtist!.artistImages[0].primaryColorHex);
          } else {
            if (state.searchPageResultData.result.length > 0) {
              changePlayingFrom(
                parseSearchResult(state.searchPageResultData.result[0]),
              );
            }
          }
        }
      },
    );
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  void changePlayingFrom(String colorHex) async {
    emit(HexColor(colorHex));
  }

  String parseSearchResult(dynamic item) {
    String colorHex = "";
    if (item is Artist) {
      colorHex = item.artistImages[0].primaryColorHex;
    } else if (item is Playlist) {
      colorHex = item.playlistImage.primaryColorHex;
    } else if (item is Song) {
      colorHex = item.albumArt.primaryColorHex;
    } else if (item is Album) {
      colorHex = item.albumImages[0].primaryColorHex;
    }
    return colorHex;
  }
}
