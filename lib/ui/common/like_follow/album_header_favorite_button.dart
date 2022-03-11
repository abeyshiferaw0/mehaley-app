import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/color_util.dart';

import '../app_bouncing_button.dart';

class AlbumHeaderFavoriteButton extends StatefulWidget {
  const AlbumHeaderFavoriteButton({
    Key? key,
    required this.albumId,
    required this.isLiked,
    required this.likedColor,
    required this.unlikedColor,
    required this.iconSize,
  }) : super(key: key);

  final int albumId;
  final bool isLiked;
  final double iconSize;
  final Color likedColor;
  final Color unlikedColor;

  @override
  _AlbumHeaderFavoriteButtonState createState() =>
      _AlbumHeaderFavoriteButtonState();
}

class _AlbumHeaderFavoriteButtonState extends State<AlbumHeaderFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      buildWhen: (previousState, currentState) {
        if (currentState is AlbumLikeUnlikeLoadingState ||
            currentState is AlbumLikeUnlikeErrorState ||
            currentState is AlbumLikeUnlikeSuccessState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return AppBouncingButton(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(AppPadding.padding_12),
            decoration: BoxDecoration(
              color: ColorMapper.getWhite(),
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: ColorUtil.darken(ColorMapper.getWhite(), 0.1),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              preIcon(),
              color: preIconColor(),
              size: widget.iconSize,
            ),
          ),
        );
      },
    );
  }

  void onTap() {
    ///LIKE UNLIKE ALBUM
    EasyDebounce.debounce(
      'ALBUM_LIKE',
      Duration(milliseconds: 0),
      () {
        BlocProvider.of<LibraryBloc>(context).add(
          LikeUnLikeAlbumEvent(
            id: widget.albumId,
            appLikeFollowEvents: preButtonOnTap()
                ? AppLikeFollowEvents.UNLIKE
                : AppLikeFollowEvents.LIKE,
          ),
        );
      },
    );
  }

  IconData preIcon() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
            .containsKey(widget.albumId) &&
        AppHiveBoxes.instance.recentlyUnLikedAlbumBox
            .containsKey(widget.albumId)) {
      int a = AppHiveBoxes.instance.recentlyLikedAlbumBox.get(widget.albumId);
      int b = AppHiveBoxes.instance.recentlyUnLikedAlbumBox.get(widget.albumId);
      if (a > b) {
        return FlutterRemix.heart_fill;
      } else {
        return FlutterRemix.heart_line;
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
        .containsKey(widget.albumId)) {
      return FlutterRemix.heart_fill;
    }

    ///IF ALBUM IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedAlbumBox
        .containsKey(widget.albumId)) {
      return FlutterRemix.heart_line;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (widget.isLiked) {
      return FlutterRemix.heart_fill;
    } else {
      return FlutterRemix.heart_line;
    }
  }

  Color preIconColor() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
            .containsKey(widget.albumId) &&
        AppHiveBoxes.instance.recentlyUnLikedAlbumBox
            .containsKey(widget.albumId)) {
      int a = AppHiveBoxes.instance.recentlyLikedAlbumBox.get(widget.albumId);
      int b = AppHiveBoxes.instance.recentlyUnLikedAlbumBox.get(widget.albumId);
      if (a > b) {
        return ColorMapper.getDarkOrange();
      } else {
        return ColorMapper.getDarkOrange();
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
        .containsKey(widget.albumId)) {
      return widget.likedColor;
    }

    ///IF ALBUM IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedAlbumBox
        .containsKey(widget.albumId)) {
      return widget.unlikedColor;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (widget.isLiked) {
      return widget.likedColor;
    } else {
      return widget.unlikedColor;
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
            .containsKey(widget.albumId) &&
        AppHiveBoxes.instance.recentlyUnLikedAlbumBox
            .containsKey(widget.albumId)) {
      int a = AppHiveBoxes.instance.recentlyLikedAlbumBox.get(widget.albumId);
      int b = AppHiveBoxes.instance.recentlyUnLikedAlbumBox.get(widget.albumId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
        .containsKey(widget.albumId)) {
      return true;
    }

    ///IF ALBUM IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedAlbumBox
        .containsKey(widget.albumId)) {
      return false;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    return widget.isLiked;
  }
}
