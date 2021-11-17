import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';

import 'menu_item.dart';

class SongCartMenuItem extends StatefulWidget {
  const SongCartMenuItem({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  _SongCartMenuItemState createState() => _SongCartMenuItemState();
}

class _SongCartMenuItemState extends State<SongCartMenuItem> {
  @override
  @override
  Widget build(BuildContext context) {
    if (widget.song.isBought || widget.song.isFree) {
      return SizedBox();
    } else {
      return BlocBuilder<CartUtilBloc, CartUtilState>(
        buildWhen: (previousState, currentState) {
          if (currentState is CartUtilSongAddingState ||
              currentState is CartUtilSongAddedSuccessState ||
              currentState is CartUtilSongAddingErrorState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return MenuItem(
            isDisabled: false,
            hasTopMargin: true,
            iconColor: preCartIconColor(),
            icon: preCartIcon(),
            title: preCartText(),
            onTap: () {
              onTap();
            },
          );
        },
      );
    }
  }

  void onTap() {
    ///ADD REMOVE SONG
    EasyDebounce.debounce(
      'SONG_CART_ADD_REMOVE',
      Duration(milliseconds: 0),
      () {
        BlocProvider.of<CartUtilBloc>(context).add(
          AddRemovedSongCartEvent(
            song: widget.song,
            appCartAddRemoveEvents: preButtonOnTap()
                ? AppCartAddRemoveEvents.REMOVE
                : AppCartAddRemoveEvents.ADD,
          ),
        );
      },
    );
  }

  IconData preCartIcon() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
            .containsKey(widget.song.songId) &&
        AppHiveBoxes.instance.recentlyCartRemovedSongBox
            .containsKey(widget.song.songId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedSongBox
          .get(widget.song.songId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedSongBox
          .get(widget.song.songId);
      if (a > b) {
        return FlutterRemix.shopping_cart_2_fill;
      } else {
        return FlutterRemix.shopping_cart_2_line;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return FlutterRemix.shopping_cart_2_fill;
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return FlutterRemix.shopping_cart_2_line;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.song.isInCart) {
      return FlutterRemix.shopping_cart_2_fill;
    } else {
      return FlutterRemix.shopping_cart_2_line;
    }
  }

  Color preCartIconColor() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
            .containsKey(widget.song.songId) &&
        AppHiveBoxes.instance.recentlyCartRemovedSongBox
            .containsKey(widget.song.songId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedSongBox
          .get(widget.song.songId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedSongBox
          .get(widget.song.songId);
      if (a > b) {
        return AppColors.darkOrange;
      } else {
        return AppColors.grey.withOpacity(0.6);
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return AppColors.darkOrange;
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return AppColors.grey.withOpacity(0.6);
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.song.isInCart) {
      return AppColors.darkOrange;
    } else {
      return AppColors.grey.withOpacity(0.6);
    }
  }

  String preCartText() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
            .containsKey(widget.song.songId) &&
        AppHiveBoxes.instance.recentlyCartRemovedSongBox
            .containsKey(widget.song.songId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedSongBox
          .get(widget.song.songId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedSongBox
          .get(widget.song.songId);
      if (a > b) {
        return AppLocale.of().removeFromCart;
      } else {
        return AppLocale.of().addToCart;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return AppLocale.of().removeFromCart;
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return AppLocale.of().addToCart;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.song.isInCart) {
      return AppLocale.of().removeFromCart;
    } else {
      return AppLocale.of().addToCart;
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
            .containsKey(widget.song.songId) &&
        AppHiveBoxes.instance.recentlyCartRemovedSongBox
            .containsKey(widget.song.songId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedSongBox
          .get(widget.song.songId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedSongBox
          .get(widget.song.songId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return true;
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return false;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    return widget.song.isInCart;
  }
}
