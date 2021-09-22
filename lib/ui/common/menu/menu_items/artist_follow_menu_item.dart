import 'package:elf_play/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/menu/menu_items/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

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
          icon: PhosphorIcons.hand_pointing_light,
          title: preButtonText(),
          onTap: onTap,
        );
      },
    );
  }

  void onTap() {
    ///FOLLOW UNFOLLOW ARTIST
    BlocProvider.of<LibraryBloc>(context).add(
      FollowUnFollowArtistEvent(
        id: widget.artistId,
        appLikeFollowEvents: preButtonOnTap()
            ? AppLikeFollowEvents.UNFOLLOW
            : AppLikeFollowEvents.FOLLOW,
      ),
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
        return "Remove from followed artist";
      } else {
        return "Follow artist";
      }
    }

    ///IF  FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox
        .containsKey(widget.artistId)) {
      return "Remove from followed artist";
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedArtistBox
        .containsKey(widget.artistId)) {
      return "Follow artist";
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (widget.isFollowing) {
      return "Remove from followed artist";
    } else {
      return "Follow artist";
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
        return AppColors.darkGreen;
      } else {
        return AppColors.white.withOpacity(0.3);
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox
        .containsKey(widget.artistId)) {
      return AppColors.darkGreen;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedArtistBox
        .containsKey(widget.artistId)) {
      return AppColors.white.withOpacity(0.3);
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    print("preBorderColor isFollowing");
    if (widget.isFollowing) {
      return AppColors.darkGreen;
    } else {
      return AppColors.white.withOpacity(0.3);
    }
  }
}
