import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/menu/menu_items/menu_item.dart';

class PlaylistFollowMenuItem extends StatefulWidget {
  const PlaylistFollowMenuItem({
    Key? key,
    required this.isFollowing,
    required this.playlistId,
  }) : super(key: key);

  final bool isFollowing;
  final int playlistId;

  @override
  _PlaylistFollowMenuItemState createState() => _PlaylistFollowMenuItemState();
}

class _PlaylistFollowMenuItemState extends State<PlaylistFollowMenuItem> {
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
        return MenuItem(
          isDisabled: false,
          hasTopMargin: true,
          iconColor: preIconColor(),
          icon: FlutterRemix.record_circle_line,
          title: preButtonText(),
          onTap: onTap,
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
        return AppLocale.of().removeFromFollowedPlaylist;
      } else {
        return AppLocale.of().followPlaylist;
      }
    }

    ///IF  FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return AppLocale.of().removeFromFollowedPlaylist;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return AppLocale.of().followPlaylist;
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (widget.isFollowing) {
      return AppLocale.of().removeFromFollowedPlaylist;
    } else {
      return AppLocale.of().followPlaylist;
    }
  }

  Color preIconColor() {
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
        return ColorMapper.getDarkOrange();
      } else {
        return ColorMapper.getBlack().withOpacity(0.3);
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return ColorMapper.getDarkOrange();
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox
        .containsKey(widget.playlistId)) {
      return ColorMapper.getBlack().withOpacity(0.3);
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (widget.isFollowing) {
      return ColorMapper.getDarkOrange();
    } else {
      return ColorMapper.getBlack().withOpacity(0.3);
    }
  }
}
