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
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class PlaylistSliverFollowButton extends StatefulWidget {
  const PlaylistSliverFollowButton({
    Key? key,
    required this.isFollowing,
    required this.playlistId,
    required this.iconSize,
    required this.iconColor,
  }) : super(key: key);

  final bool isFollowing;
  final int playlistId;
  final double iconSize;
  final Color iconColor;

  @override
  _PlaylistSliverFollowButtonState createState() =>
      _PlaylistSliverFollowButtonState();
}

class _PlaylistSliverFollowButtonState
    extends State<PlaylistSliverFollowButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      buildWhen: (previousState, currentState) {
        if (currentState is PlaylistFollowUnFollowLoadingState ||
            currentState is PlaylistFollowUnFollowErrorState ||
            currentState is PlaylistFollowUnFollowSuccessState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return AppBouncingButton(
          onTap: onTap,
          child: Container(
            height: AppIconSizes.icon_size_40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: AppColors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: AppMargin.margin_16),
                Icon(
                  FlutterRemix.record_circle_line,
                  color: widget.iconColor,
                  size: widget.iconSize,
                ),
                SizedBox(width: AppMargin.margin_8),
                Text(
                  preButtonText(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSizes.font_size_8.sp - 1,
                  ),
                ),
                SizedBox(width: AppMargin.margin_16),
              ],
            ),
          ),
        );
      },
    );
  }

  void onTap() {
    ///FOLLOW UNFOLLOW PLAYLIST
    EasyDebounce.debounce(
      'PLAYLIST_FOLLOW',
      Duration(milliseconds: 0),
      () {
        BlocProvider.of<LibraryBloc>(context).add(
          FollowUnFollowPlaylistEvent(
            id: widget.playlistId,
            appLikeFollowEvents: preButtonOnTap()
                ? AppLikeFollowEvents.UNFOLLOW
                : AppLikeFollowEvents.FOLLOW,
          ),
        );
      },
    );
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY FOLLOWED AND UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
            .containsKey(widget.playlistId) &&
        AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
            .containsKey(widget.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyFollowedPlaylistBox
          .get(widget.playlistId);

      int b = AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
          .get(widget.playlistId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return true;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return false;
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    return widget.isFollowing;
  }

  String preButtonText() {
    ///IF FOUND IN BOTH RECENTLY FOLLOWED AND UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
            .containsKey(widget.playlistId) &&
        AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
            .containsKey(widget.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyFollowedPlaylistBox
          .get(widget.playlistId);

      int b = AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
          .get(widget.playlistId);
      if (a > b) {
        return AppLocale.of().following.toUpperCase();
      } else {
        return AppLocale.of().follow.toUpperCase();
      }
    }

    ///IF  FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return AppLocale.of().following.toUpperCase();
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return AppLocale.of().follow.toUpperCase();
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (widget.isFollowing) {
      return AppLocale.of().following.toUpperCase();
    } else {
      return AppLocale.of().follow.toUpperCase();
    }
  }
}
