import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class PlaylistFollowButton extends StatefulWidget {
  const PlaylistFollowButton({
    Key? key,
    required this.isFollowing,
    required this.playlistId,
  }) : super(key: key);

  final bool isFollowing;
  final int playlistId;

  @override
  _PlaylistFollowButtonState createState() => _PlaylistFollowButtonState();
}

class _PlaylistFollowButtonState extends State<PlaylistFollowButton> {
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
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_20,
              vertical: AppPadding.padding_4,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: preBorderColor(),
                width: widget.isFollowing ? 1.5 : 1.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Text(
              preButtonText(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: AppColors.black,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
              ),
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
      Duration(milliseconds: 800),
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

  Color preBorderColor() {
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
        return AppColors.darkOrange;
      } else {
        return AppColors.black;
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return AppColors.darkOrange;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return AppColors.black;
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (widget.isFollowing) {
      return AppColors.orange;
    } else {
      return AppColors.black;
    }
  }
}
