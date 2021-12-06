import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';

class AlbumFavoriteMenuItem extends StatefulWidget {
  const AlbumFavoriteMenuItem({
    Key? key,
    required this.albumId,
    required this.isLiked,
    required this.hasTopMargin,
    required this.isDisabled,
    required this.likedColor,
    required this.unlikedColor,
  }) : super(key: key);

  final int albumId;
  final bool isLiked;
  final bool hasTopMargin;
  final bool isDisabled;
  final Color likedColor;
  final Color unlikedColor;

  @override
  _AlbumFavoriteMenuItemState createState() => _AlbumFavoriteMenuItemState();
}

class _AlbumFavoriteMenuItemState extends State<AlbumFavoriteMenuItem> {
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      preIcon(),
                      size: AppIconSizes.icon_size_24,
                      color: preIconColor(),
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

  Color preIconColor() {
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

  IconData preIcon() {
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

  bool preButtonOnTap() {
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

  String preButtonText() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
            .containsKey(widget.albumId) &&
        AppHiveBoxes.instance.recentlyUnLikedAlbumBox
            .containsKey(widget.albumId)) {
      int a = AppHiveBoxes.instance.recentlyLikedAlbumBox.get(widget.albumId);
      int b = AppHiveBoxes.instance.recentlyUnLikedAlbumBox.get(widget.albumId);
      if (a > b) {
        return AppLocale.of().removeFromFavorite;
      } else {
        return AppLocale.of().addToFavorite;
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
        .containsKey(widget.albumId)) {
      return AppLocale.of().removeFromFavorite;
    }

    ///IF ALBUM IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedAlbumBox
        .containsKey(widget.albumId)) {
      return AppLocale.of().addToFavorite;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (widget.isLiked) {
      return AppLocale.of().removeFromFavorite;
    } else {
      return AppLocale.of().addToFavorite;
    }
  }
}
