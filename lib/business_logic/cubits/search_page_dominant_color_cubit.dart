import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:flutter/cupertino.dart';

class SearchPageDominantColorCubit extends Cubit<Color> {
  final SearchResultBloc searchResultBloc;
  late StreamSubscription streamSubscription;

  SearchPageDominantColorCubit({required this.searchResultBloc})
      : super(AppColors.appGradientDefaultColorBlack) {
    streamSubscription = searchResultBloc.stream.listen(
      (state) {
        if (state is SearchResultPageLoadedState) {
          if (state.searchPageResultData.topArtistData.topArtist != null) {
            changePlayingFrom(
              AppApi.baseFileUrl +
                  state.searchPageResultData.topArtistData.topArtist!
                      .artistImages[0].imageSmallPath,
            );
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

  void changePlayingFrom(String imageUrl) async {
    ImageProvider? imageProvider = ColorUtil.getImageProvider(imageUrl);
    if (imageProvider != null) {
      print("changePlayingFrom2 $imageUrl");
      Color dominantColor = await ColorUtil.getDarkImagePalette(imageProvider);
      print("changePlayingFrom3 ${dominantColor.toString()}");
      emit(dominantColor);
    }
  }

  String parseSearchResult(dynamic item) {
    String imageUrl = "";
    if (item is Artist) {
      imageUrl = AppApi.baseFileUrl + item.artistImages[0].imageSmallPath;
    } else if (item is Playlist) {
      imageUrl = AppApi.baseFileUrl + item.playlistImage.imageSmallPath;
    } else if (item is Song) {
      imageUrl = AppApi.baseFileUrl + item.albumArt.imageSmallPath;
    } else if (item is Album) {
      imageUrl = AppApi.baseFileUrl + item.albumImages[0].imageSmallPath;
    }
    return imageUrl;
  }
}
