import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';

class SongFavoriteMenuItem extends StatefulWidget {
  const SongFavoriteMenuItem({
    Key? key,
    required this.songId,
    required this.isLiked,
    required this.hasTopMargin,
    required this.isDisabled,
  }) : super(key: key);

  final int songId;
  final bool isLiked;
  final bool hasTopMargin;
  final bool isDisabled;

  @override
  _SongFavoriteMenuItemState createState() => _SongFavoriteMenuItemState();
}

class _SongFavoriteMenuItemState extends State<SongFavoriteMenuItem>
    with TickerProviderStateMixin {
  late AnimationController controller;

  void initState() {
    ///INIT ANIMATION CONTROLLER
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    ///PRE ANIMATE
    preAnimate();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        preAnimate();
        return Column(
          children: [
            ///ADD TOP MARGIN IF WANTED
            widget.hasTopMargin
                ? SizedBox(height: AppMargin.margin_12)
                : SizedBox(),
            AppBouncingButton(
              onTap: !widget.isDisabled ? onTap : () {},
              disableBouncing: widget.isDisabled,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.padding_4,
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppIconSizes.icon_size_32,
                      height: AppIconSizes.icon_size_32,
                      child: Stack(
                        children: [
                          Positioned(
                            right: AppPadding.padding_4,
                            child: Container(
                              width: AppIconSizes.icon_size_32,
                              height: AppIconSizes.icon_size_32,
                              child: Opacity(
                                opacity: preButtonOnTap() ? 1.0 : 0.3,
                                child: LottieBuilder.asset(
                                  'assets/lottie/heart.json',
                                  controller: controller,
                                  fit: BoxFit.cover,
                                  onLoaded: (composition) {
                                    controller.duration = composition.duration;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppMargin.margin_12),
                    Text(
                      preButtonText(),
                      style: TextStyle(
                        color: !widget.isDisabled
                            ? AppColors.black
                            : AppColors.black.withOpacity(0.4),
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void onTap() {
    ///LIKE UNLIKE SONG
    EasyDebounce.debounce(
      'SONG_LIKE',
      Duration(milliseconds: 800),
      () {
        BlocProvider.of<LibraryBloc>(context).add(
          LikeUnlikeSongEvent(
            id: widget.songId,
            appLikeFollowEvents: preButtonOnTap()
                ? AppLikeFollowEvents.UNLIKE
                : AppLikeFollowEvents.LIKE,
          ),
        );
      },
    );
  }

  void preAnimate() {
    ///FLAG FOR SONG FOUND IN RECENTLY LIKED OR UNLIKED
    bool songRecentlyLikedUnliked = false;

    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId) &&
        AppHiveBoxes.instance.recentlyUnLikedSongBox
            .containsKey(widget.songId)) {
      int a = AppHiveBoxes.instance.recentlyLikedSongBox.get(widget.songId);
      int b = AppHiveBoxes.instance.recentlyUnLikedSongBox.get(widget.songId);
      if (a > b) {
        controller.forward();
      } else {
        controller.reset();
      }
      songRecentlyLikedUnliked = true;
    }

    ///IF SONG IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId)) {
      controller.forward();
      songRecentlyLikedUnliked = true;
    }

    ///IF SONG IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedSongBox
        .containsKey(widget.songId)) {
      controller.reset();
      songRecentlyLikedUnliked = true;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (songRecentlyLikedUnliked == false) {
      if (widget.isLiked) {
        controller.forward();
      } else {
        controller.reset();
      }
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId) &&
        AppHiveBoxes.instance.recentlyUnLikedSongBox
            .containsKey(widget.songId)) {
      int a = AppHiveBoxes.instance.recentlyLikedSongBox.get(widget.songId);
      int b = AppHiveBoxes.instance.recentlyUnLikedSongBox.get(widget.songId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId)) {
      return true;
    }

    ///IF SONG IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedSongBox
        .containsKey(widget.songId)) {
      return false;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    return widget.isLiked;
  }

  String preButtonText() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId) &&
        AppHiveBoxes.instance.recentlyUnLikedSongBox
            .containsKey(widget.songId)) {
      int a = AppHiveBoxes.instance.recentlyLikedSongBox.get(widget.songId);
      int b = AppHiveBoxes.instance.recentlyUnLikedSongBox.get(widget.songId);
      if (a > b) {
        return AppLocale.of().removeFromFavorite;
      } else {
        return AppLocale.of().addToFavorite;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedSongBox.containsKey(widget.songId)) {
      return AppLocale.of().removeFromFavorite;
    }

    ///IF SONG IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedSongBox
        .containsKey(widget.songId)) {
      return AppLocale.of().addToFavorite;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (widget.isLiked) {
      return AppLocale.of().removeFromFavorite;
    } else {
      return AppLocale.of().addToFavorite;
    }
  }
}
