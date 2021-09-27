import 'package:easy_debounce/easy_debounce.dart';
import 'package:elf_play/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/dialog/dialog_unlike_unfollow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            child: preButtonOnTap() ? buildFollowingBtn() : buildFollowBtn(),
          ),
        );
      },
    );
  }

  void onTap(context) {
    if (askDialog && preButtonOnTap()) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: DialogUlLikeUnFollow(
              mainButtonText: 'UNFOLLOW'.toUpperCase(),
              cancelButtonText: 'CANCEL',
              titleText: 'Remove From Followed Artists?',
              onUnLikeUnFollow: () {
                ///FOLLOW UNFOLLOW ARTIST
                BlocProvider.of<LibraryBloc>(context).add(
                  FollowUnFollowArtistEvent(
                    id: artistId,
                    appLikeFollowEvents: preButtonOnTap()
                        ? AppLikeFollowEvents.UNFOLLOW
                        : AppLikeFollowEvents.FOLLOW,
                  ),
                );
              },
            ),
          );
        },
      );
    }

    ///FOLLOW UNFOLLOW ARTIST

    EasyDebounce.debounce(
      "ARTIST_FOLLOW",
      Duration(milliseconds: 800),
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

  Container buildFollowingBtn() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_8,
        vertical: AppMargin.margin_6,
      ),
      child: Text(
        "FOLLOWING",
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          fontWeight: FontWeight.w200,
          letterSpacing: 1,
          color: AppColors.white,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: AppColors.white, width: 1),
      ),
    );
  }

  Container buildFollowBtn() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_16,
        vertical: AppMargin.margin_6,
      ),
      child: Text(
        "FOLLOW",
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          fontWeight: FontWeight.w200,
          letterSpacing: 1,
          color: AppColors.white,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
