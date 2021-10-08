import 'package:easy_debounce/easy_debounce.dart';
import 'package:elf_play/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';

class AlbumFavoriteMenuItem extends StatefulWidget {
  const AlbumFavoriteMenuItem({
    Key? key,
    required this.albumId,
    required this.isLiked,
    required this.hasTopMargin,
    required this.isDisabled,
  }) : super(key: key);

  final int albumId;
  final bool isLiked;
  final bool hasTopMargin;
  final bool isDisabled;

  @override
  _AlbumFavoriteMenuItemState createState() => _AlbumFavoriteMenuItemState();
}

class _AlbumFavoriteMenuItemState extends State<AlbumFavoriteMenuItem>
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
                                  "assets/lottie/heart.json",
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
                            ? AppColors.white
                            : AppColors.white.withOpacity(0.4),
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
    ///LIKE UNLIKE ALBUM

    EasyDebounce.debounce(
      "ALBUM_LIKE",
      Duration(milliseconds: 800),
      () {
        BlocProvider.of<LibraryBloc>(context).add(
          LikeUnLikeAlbumEvent(
            id: widget.albumId,
            appLikeFollowEvents: preButtonOnTap()
                ? AppLikeFollowEvents.UNLIKE
                : AppLikeFollowEvents.LIKE,
          ),
        );
      },
    );
  }

  void preAnimate() {
    ///FLAG FOR ALBUM FOUND IN RECENTLY LIKED OR UNLIKED
    bool albumRecentlyLikedUnliked = false;

    ///IF ALBUM IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
        .containsKey(widget.albumId)) {
      controller.forward();
      albumRecentlyLikedUnliked = true;
    }

    ///IF ALBUM IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedAlbumBox
        .containsKey(widget.albumId)) {
      controller.reset();
      albumRecentlyLikedUnliked = true;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (albumRecentlyLikedUnliked == false) {
      if (widget.isLiked) {
        controller.forward();
      } else {
        controller.reset();
      }
    }
  }

  bool preButtonOnTap() {
    ///IF ALBUM IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
        .containsKey(widget.albumId)) {
      return true;
    }

    ///IF ALBUM IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedAlbumBox
        .containsKey(widget.albumId)) {
      return false;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    return widget.isLiked;
  }

  String preButtonText() {
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
            .containsKey(widget.albumId) &&
        AppHiveBoxes.instance.recentlyUnLikedAlbumBox
            .containsKey(widget.albumId)) {
      int a = AppHiveBoxes.instance.recentlyLikedAlbumBox.get(widget.albumId);
      int b = AppHiveBoxes.instance.recentlyUnLikedAlbumBox.get(widget.albumId);
      if (a > b) {
        return "Remove from favorite";
      } else {
        return "Add to favorite";
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY LIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
        .containsKey(widget.albumId)) {
      return "Remove from favorite";
    }

    ///IF ALBUM IS FOUND IN RECENTLY UNLIKED
    if (AppHiveBoxes.instance.recentlyUnLikedAlbumBox
        .containsKey(widget.albumId)) {
      return "Add to favorite";
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY UNLIKED USE ORIGINAL STATE
    if (widget.isLiked) {
      return "Remove from favorite";
    } else {
      return "Add to favorite";
    }
  }
}
