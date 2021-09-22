import 'package:elf_play/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                color: AppColors.white,
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
    BlocProvider.of<LibraryBloc>(context).add(
      FollowUnFollowPlaylistEvent(
        id: widget.playlistId,
        appLikeFollowEvents: preButtonOnTap()
            ? AppLikeFollowEvents.UNFOLLOW
            : AppLikeFollowEvents.FOLLOW,
      ),
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
        return "FOLLOWING";
      } else {
        return "FOLLOW";
      }
    }

    ///IF  FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return "FOLLOWING";
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return "FOLLOW";
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (widget.isFollowing) {
      return "FOLLOWING";
    } else {
      return "FOLLOW";
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
        return AppColors.darkGreen;
      } else {
        return AppColors.white;
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      print("preBorderColor recentlyFollowedPlaylistBox");
      return AppColors.darkGreen;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      print("preBorderColor recentlyUnFollowedPlaylistBox");
      return AppColors.white;
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    print("preBorderColor isFollowing");
    if (widget.isFollowing) {
      return AppColors.green;
    } else {
      return AppColors.white;
    }
  }
}
