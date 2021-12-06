import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/menu/menu_items/menu_item.dart';

class ArtistFollowMenuItem extends StatefulWidget {
  const ArtistFollowMenuItem({
    Key? key,
    required this.isFollowing,
    required this.artistId,
  }) : super(key: key);

  final bool isFollowing;
  final int artistId;

  @override
  _ArtistFollowMenuItemState createState() => _ArtistFollowMenuItemState();
}

class _ArtistFollowMenuItemState extends State<ArtistFollowMenuItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      buildWhen: (previousState, currentState) {
        if (currentState is ArtistFollowUnFollowLoadingState ||
            currentState is ArtistFollowUnFollowErrorState ||
            currentState is ArtistFollowUnFollowSuccessState) {
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
    ///FOLLOW UNFOLLOW ARTIST
    EasyDebounce.debounce(
      'ARTIST_FOLLOW',
      Duration(milliseconds: 0),
      () {
        BlocProvider.of<LibraryBloc>(context).add(
          FollowUnFollowArtistEvent(
            id: widget.artistId,
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
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox
            .containsKey(widget.artistId) &&
        AppHiveBoxes.instance.recentlyUnFollowedArtistBox
            .containsKey(widget.artistId)) {
      int a =
          AppHiveBoxes.instance.recentlyFollowedArtistBox.get(widget.artistId);

      int b = AppHiveBoxes.instance.recentlyUnFollowedArtistBox
          .get(widget.artistId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox
        .containsKey(widget.artistId)) {
      return true;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedArtistBox
        .containsKey(widget.artistId)) {
      return false;
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    return widget.isFollowing;
  }

  String preButtonText() {
    ///IF FOUND IN BOTH RECENTLY FOLLOWED AND UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox
            .containsKey(widget.artistId) &&
        AppHiveBoxes.instance.recentlyUnFollowedArtistBox
            .containsKey(widget.artistId)) {
      int a =
          AppHiveBoxes.instance.recentlyFollowedArtistBox.get(widget.artistId);

      int b = AppHiveBoxes.instance.recentlyUnFollowedArtistBox
          .get(widget.artistId);
      if (a > b) {
        return AppLocale.of().removeFromFollowedArtist;
      } else {
        return AppLocale.of().followArtist;
      }
    }

    ///IF  FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox
        .containsKey(widget.artistId)) {
      return AppLocale.of().removeFromFollowedArtist;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedArtistBox
        .containsKey(widget.artistId)) {
      return AppLocale.of().followArtist;
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (widget.isFollowing) {
      return AppLocale.of().removeFromFollowedArtist;
    } else {
      return AppLocale.of().followArtist;
    }
  }

  Color preIconColor() {
    ///IF FOUND IN BOTH RECENTLY FOLLOWED AND UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox
            .containsKey(widget.artistId) &&
        AppHiveBoxes.instance.recentlyUnFollowedArtistBox
            .containsKey(widget.artistId)) {
      int a =
          AppHiveBoxes.instance.recentlyFollowedArtistBox.get(widget.artistId);

      int b = AppHiveBoxes.instance.recentlyUnFollowedArtistBox
          .get(widget.artistId);
      if (a > b) {
        return AppColors.darkOrange;
      } else {
        return AppColors.black.withOpacity(0.3);
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox
        .containsKey(widget.artistId)) {
      return AppColors.darkOrange;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedArtistBox
        .containsKey(widget.artistId)) {
      return AppColors.black.withOpacity(0.3);
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (widget.isFollowing) {
      return AppColors.darkOrange;
    } else {
      return AppColors.black.withOpacity(0.3);
    }
  }
}
