import 'package:easy_debounce/easy_debounce.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class AlbumFavoriteButton extends StatefulWidget {
  const AlbumFavoriteButton({
    Key? key,
    required this.albumId,
    required this.isLiked,
    required this.padding,
  }) : super(key: key);

  final int albumId;
  final bool isLiked;
  final EdgeInsets padding;

  @override
  _AlbumFavoriteButtonState createState() => _AlbumFavoriteButtonState();
}

class _AlbumFavoriteButtonState extends State<AlbumFavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    ///INIT ANIMATION CONTROLLER
    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
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
      buildWhen: (previousState, currentState) {
        if (currentState is AlbumLikeUnlikeLoadingState ||
            currentState is AlbumLikeUnlikeErrorState ||
            currentState is AlbumLikeUnlikeSuccessState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        preAnimate();

        return Container(
          padding: widget.padding,
          child: AppBouncingButton(
            onTap: onTap,
            child: Container(
              width: AppIconSizes.icon_size_36,
              height: AppIconSizes.icon_size_36,
              padding: EdgeInsets.all(AppPadding.padding_4),
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
        );
      },
    );
  }

  void onTap() {
    ///LIKE UNLIKE ALBUM
    EasyDebounce.debounce(
      'ALBUM_LIKE',
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

    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
            .containsKey(widget.albumId) &&
        AppHiveBoxes.instance.recentlyUnLikedAlbumBox
            .containsKey(widget.albumId)) {
      int a = AppHiveBoxes.instance.recentlyLikedAlbumBox.get(widget.albumId);
      int b = AppHiveBoxes.instance.recentlyUnLikedAlbumBox.get(widget.albumId);
      if (a > b) {
        controller.forward();
      } else {
        controller.reset();
      }
      albumRecentlyLikedUnliked = true;
    }

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
    ///IF FOUND IN BOTH RECENTLY LIKED AND UNLIKED
    if (AppHiveBoxes.instance.recentlyLikedAlbumBox
            .containsKey(widget.albumId) &&
        AppHiveBoxes.instance.recentlyUnLikedAlbumBox
            .containsKey(widget.albumId)) {
      int a = AppHiveBoxes.instance.recentlyLikedAlbumBox.get(widget.albumId);
      int b = AppHiveBoxes.instance.recentlyUnLikedAlbumBox.get(widget.albumId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

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
}
