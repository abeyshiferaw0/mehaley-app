import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';

class SongFavoriteMenuItem extends StatefulWidget {
  const SongFavoriteMenuItem({
    Key? key,
    required this.songId,
    required this.isLiked,
    required this.hasTopMargin,
    required this.isDisabled,
    required this.likedColor,
    required this.unlikedColor,
  }) : super(key: key);

  final int songId;
  final bool isLiked;
  final bool hasTopMargin;
  final bool isDisabled;
  final Color likedColor;
  final Color unlikedColor;

  @override
  _SongFavoriteMenuItemState createState() => _SongFavoriteMenuItemState();
}

class _SongFavoriteMenuItemState extends State<SongFavoriteMenuItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        return Column(
          children: [
            ///ADD TOP MARGIN IF WANTED
            widget.hasTopMargin
                ? SizedBox(height: AppMargin.margin_12)
                : SizedBox(),
            AppBouncingButton(
              onTap: !widget.isDisabled ? onTap : () {},
              disableBouncing: widget.isDisabled,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.padding_4,
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppIconSizes.icon_size_32,
                      height: AppIconSizes.icon_size_32,
                      child: Stack(
                        children: [
                          Positioned(
                            right: AppPadding.padding_4,
                            child: Container(
                              width: AppIconSizes.icon_size_32,
                              height: AppIconSizes.icon_size_32,
                              child: Icon(
                                preIcon(),
                                size: AppIconSizes.icon_size_24,
                                color: preIconColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppMargin.margin_12),
                    Text(
                      preButtonText(),
                      style: TextStyle(
                        color: !widget.isDisabled
                            ? AppColors.black
                            : AppColors.black.withOpacity(0.4),
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  String preButtonText() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId) &&
        AppHiveBoxes.instance.recentlyUnLikedSongBox
            .containsKey(widget.songId)) {
      int a = AppHiveBoxes.instance.recentlyLikedSongBox.get(widget.songId);
      int b = AppHiveBoxes.instance.recentlyUnLikedSongBox.get(widget.songId);
      if (a > b) {
        return AppLocale.of().removeFromFavorite;
      } else {
        return AppLocale.of().addToFavorite;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId)) {
      return AppLocale.of().removeFromFavorite;
    }

    ///IF SONG IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedSongBox
        .containsKey(widget.songId)) {
      return AppLocale.of().addToFavorite;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (widget.isLiked) {
      return AppLocale.of().removeFromFavorite;
    } else {
      return AppLocale.of().addToFavorite;
    }
  }
}
