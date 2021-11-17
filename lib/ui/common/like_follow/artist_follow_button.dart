import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/dialog/dialog_unlike_unfollow.dart';
import 'package:sizer/sizer.dart';

import '../app_bouncing_button.dart';

class ArtistFollowButton extends StatelessWidget {
  final bool isFollowing;
  final int artistId;
  final bool askDialog;

  const ArtistFollowButton(
      {required this.isFollowing,
      required this.artistId,
      required this.askDialog});

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
            child: preButtonOnTap()
                ? buildFollowingBtn(context)
                : buildFollowBtn(context),
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

  Container buildFollowingBtn(context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_8,
        vertical: AppMargin.margin_6,
      ),
      child: Text(
        AppLocale.of().following.toUpperCase(),
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          fontWeight: FontWeight.w200,
          letterSpacing: 1,
          color: AppColors.black,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: AppColors.black, width: 1),
      ),
    );
  }

  Container buildFollowBtn(context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_16,
        vertical: AppMargin.margin_6,
      ),
      child: Text(
        AppLocale.of().follow.toUpperCase(),
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          fontWeight: FontWeight.w200,
          letterSpacing: 1,
          color: AppColors.black,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
