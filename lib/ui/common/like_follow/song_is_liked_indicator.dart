import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/dialog/dialog_unlike_unfollow.dart';

class SongIsLikedIndicator extends StatelessWidget {
  const SongIsLikedIndicator({
    Key? key,
    required this.isLiked,
    required this.songId,
  }) : super(key: key);

  final bool isLiked;
  final int songId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (preAnimate()) {
          return AppBouncingButton(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: DialogUlLikeUnFollow(
                      mainButtonText: AppLocale.of().remove.toUpperCase(),
                      cancelButtonText: AppLocale.of().cancel,
                      titleText: AppLocale.of().removeFromFavoriteMezmurs,
                      onUnLikeUnFollow: () {
                        BlocProvider.of<LibraryBloc>(context).add(
                          LikeUnlikeSongEvent(
                            id: songId,
                            appLikeFollowEvents: preAnimate()
                                ? AppLikeFollowEvents.UNLIKE
                                : AppLikeFollowEvents.LIKE,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.all(AppPadding.padding_8),
              child: Icon(
                PhosphorIcons.heart_straight_fill,
                color: AppColors.darkOrange,
                size: AppIconSizes.icon_size_20,
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  bool preAnimate() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(songId) &&
        AppHiveBoxes.instance.recentlyUnLikedSongBox.containsKey(songId)) {
      int a = AppHiveBoxes.instance.recentlyLikedSongBox.get(songId);
      int b = AppHiveBoxes.instance.recentlyUnLikedSongBox.get(songId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(songId)) {
      return true;
    }

    ///IF SONG IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedSongBox.containsKey(songId)) {
      return false;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    return isLiked;
  }
}
