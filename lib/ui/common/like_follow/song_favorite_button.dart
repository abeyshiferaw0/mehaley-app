import 'package:easy_debounce/easy_debounce.dart';
import 'package:elf_play/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SongFavoriteButton extends StatefulWidget {
  const SongFavoriteButton({
    Key? key,
    required this.songId,
    required this.isLiked,
  }) : super(key: key);

  final int songId;
  final bool isLiked;

  @override
  _SongFavoriteButtonState createState() => _SongFavoriteButtonState();
}

class _SongFavoriteButtonState extends State<SongFavoriteButton>
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
        if (currentState is SongLikeUnlikeLoadingState ||
            currentState is SongLikeUnlikeErrorState ||
            currentState is SongLikeUnlikeSuccessState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        preAnimate();

        return AppBouncingButton(
          onTap: onTap,
          child: Container(
            width: AppIconSizes.icon_size_36,
            height: AppIconSizes.icon_size_36,
            child: LottieBuilder.asset(
              "assets/lottie/heart.json",
              controller: controller,
              fit: BoxFit.cover,
              onLoaded: (composition) {
                controller.duration = composition.duration;
              },
            ),
          ),
        );
      },
    );
  }

  void onTap() {
    ///LIKE UNLIKE SONG
    EasyDebounce.debounce(
      "SONG_LIKE",
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
}
