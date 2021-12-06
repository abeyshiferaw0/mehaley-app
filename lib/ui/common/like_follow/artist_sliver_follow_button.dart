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
import 'package:mehaley/ui/common/dialog/dialog_unlike_unfollow.dart';
import 'package:sizer/sizer.dart';

import '../app_bouncing_button.dart';

class ArtistSliverFollowButton extends StatelessWidget {
  final bool isFollowing;
  final int artistId;
  final bool askDialog;
  final Color iconColor;
  final double iconSize;

  const ArtistSliverFollowButton({
    required this.isFollowing,
    required this.artistId,
    required this.askDialog,
    required this.iconColor,
    required this.iconSize,
  });

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
        return AppBouncingButton(
          onTap: () {
            onTap(context);
          },
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
                  color: iconColor,
                  size: iconSize,
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

  void onTap(context) {
    if (askDialog && preButtonOnTap()) {
      showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: DialogUlLikeUnFollow(
              mainButtonText: AppLocale.of().unFollow.toUpperCase(),
              cancelButtonText: AppLocale.of().cancel.toUpperCase(),
              titleText: AppLocale.of().removeFromFollowedArtist,
              onUnLikeUnFollow: () {
                ///FOLLOW UNFOLLOW ARTIST
                EasyDebounce.debounce(
                  'ARTIST_FOLLOW',
                  Duration(milliseconds: 0),
                  () {
                    print('artistId $artistId');
                    BlocProvider.of<LibraryBloc>(context).add(
                      FollowUnFollowArtistEvent(
                        id: artistId,
                        appLikeFollowEvents: preButtonOnTap()
                            ? AppLikeFollowEvents.UNFOLLOW
                            : AppLikeFollowEvents.FOLLOW,
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      );
    } else {
      ///FOLLOW UNFOLLOW ARTIST
      EasyDebounce.debounce(
        'ARTIST_FOLLOW',
        Duration(milliseconds: 0),
        () {
          BlocProvider.of<LibraryBloc>(context).add(
            FollowUnFollowArtistEvent(
              id: artistId,
              appLikeFollowEvents: preButtonOnTap()
                  ? AppLikeFollowEvents.UNFOLLOW
                  : AppLikeFollowEvents.FOLLOW,
            ),
          );
        },
      );
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY FOLLOWED AND UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox.containsKey(artistId) &&
        AppHiveBoxes.instance.recentlyUnFollowedArtistBox
            .containsKey(artistId)) {
      int a = AppHiveBoxes.instance.recentlyFollowedArtistBox.get(artistId);

      int b = AppHiveBoxes.instance.recentlyUnFollowedArtistBox.get(artistId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox.containsKey(artistId)) {
      return true;
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedArtistBox
        .containsKey(artistId)) {
      return false;
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    return isFollowing;
  }

  String preButtonText() {
    ///IF FOUND IN BOTH RECENTLY FOLLOWED AND UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox.containsKey(artistId) &&
        AppHiveBoxes.instance.recentlyUnFollowedArtistBox
            .containsKey(artistId)) {
      int a = AppHiveBoxes.instance.recentlyFollowedArtistBox.get(artistId);

      int b = AppHiveBoxes.instance.recentlyUnFollowedArtistBox.get(artistId);
      if (a > b) {
        return AppLocale.of().following.toUpperCase();
      } else {
        return AppLocale.of().follow.toUpperCase();
      }
    }

    ///IF FOUND IN RECENTLY FOLLOWED
    if (AppHiveBoxes.instance.recentlyFollowedArtistBox.containsKey(artistId)) {
      return AppLocale.of().following.toUpperCase();
    }

    ///IF FOUND IN RECENTLY UNFOLLOWED
    if (AppHiveBoxes.instance.recentlyUnFollowedArtistBox
        .containsKey(artistId)) {
      return AppLocale.of().follow.toUpperCase();
    }

    ///IF NOT FOUND IN BOTH USE ORIGINAL STATE
    if (isFollowing) {
      return AppLocale.of().following.toUpperCase();
    } else {
      return AppLocale.of().follow.toUpperCase();
    }
  }
}
