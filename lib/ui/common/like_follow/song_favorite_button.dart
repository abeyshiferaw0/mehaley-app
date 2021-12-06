import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';

class SongFavoriteButton extends StatefulWidget {
  const SongFavoriteButton({
    Key? key,
    required this.songId,
    required this.isLiked,
    required this.likedColor,
    required this.unlikedColor,
  }) : super(key: key);

  final int songId;
  final bool isLiked;
  final Color likedColor;
  final Color unlikedColor;

  @override
  _SongFavoriteButtonState createState() => _SongFavoriteButtonState();
}

class _SongFavoriteButtonState extends State<SongFavoriteButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      buildWhen: (previousState, currentState) {
        if (currentState is SongLikeUnlikeLoadingState ||
            currentState is SongLikeUnlikeErrorState ||
            currentState is SongLikeUnlikeSuccessState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return AppBouncingButton(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(
              AppPadding.padding_4,
            ),
            child: Icon(
              preIcon(),
              size: AppIconSizes.icon_size_24,
              color: preIconColor(),
            ),
          ),
        );
      },
    );
  }

  void onTap() {
    ///LIKE UNLIKE SONG
    EasyDebounce.debounce(
      'SONG_LIKE',
      Duration(milliseconds: 0),
      () {
        BlocProvider.of<LibraryBloc>(context).add(
          LikeUnlikeSongEvent(
            id: widget.songId,
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
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId) &&
        AppHiveBoxes.instance.recentlyUnLikedSongBox
            .containsKey(widget.songId)) {
      int a = AppHiveBoxes.instance.recentlyLikedSongBox.get(widget.songId);
      int b = AppHiveBoxes.instance.recentlyUnLikedSongBox.get(widget.songId);

      if (a > b) {
        return FlutterRemix.heart_fill;
      } else {
        return FlutterRemix.heart_line;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId)) {
      return FlutterRemix.heart_fill;
    }

    ///IF SONG IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedSongBox
        .containsKey(widget.songId)) {
      return FlutterRemix.heart_line;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (widget.isLiked) {
      return FlutterRemix.heart_fill;
    } else {
      return FlutterRemix.heart_line;
    }
  }

  Color preIconColor() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId) &&
        AppHiveBoxes.instance.recentlyUnLikedSongBox
            .containsKey(widget.songId)) {
      int a = AppHiveBoxes.instance.recentlyLikedSongBox.get(widget.songId);
      int b = AppHiveBoxes.instance.recentlyUnLikedSongBox.get(widget.songId);

      if (a > b) {
        return widget.likedColor;
      } else {
        return widget.unlikedColor;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId)) {
      return widget.likedColor;
    }

    ///IF SONG IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedSongBox
        .containsKey(widget.songId)) {
      return widget.unlikedColor;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (widget.isLiked) {
      return widget.likedColor;
    } else {
      return widget.unlikedColor;
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId) &&
        AppHiveBoxes.instance.recentlyUnLikedSongBox
            .containsKey(widget.songId)) {
      int a = AppHiveBoxes.instance.recentlyLikedSongBox.get(widget.songId);
      int b = AppHiveBoxes.instance.recentlyUnLikedSongBox.get(widget.songId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId)) {
      return true;
    }

    ///IF SONG IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedSongBox
        .containsKey(widget.songId)) {
      return false;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    return widget.isLiked;
  }
}
