import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class DialogSongPreviewCartButton extends StatefulWidget {
  const DialogSongPreviewCartButton({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  _DialogSongPreviewCartButtonState createState() =>
      _DialogSongPreviewCartButtonState();
}

class _DialogSongPreviewCartButtonState
    extends State<DialogSongPreviewCartButton> {
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
          return AppBouncingButton(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.padding_8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  preCartIcon(),
                  SizedBox(
                    width: AppMargin.margin_8,
                  ),
                  Text(
                    preCartText(),
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void onTap() {
    ///LIKE UNLIKE SONG
    EasyDebounce.debounce(
      'SONG_LIKE',
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

  Icon preCartIcon() {
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
        return Icon(
          FlutterRemix.shopping_cart_2_line,
          size: AppIconSizes.icon_size_20,
          color: AppColors.darkOrange,
        );
      } else {
        return Icon(
          FlutterRemix.shopping_cart_2_line,
          size: AppIconSizes.icon_size_20,
          color: AppColors.black,
        );
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_20,
        color: AppColors.darkOrange,
      );
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_20,
        color: AppColors.black,
      );
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.song.isInCart) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_20,
        color: AppColors.darkOrange,
      );
    } else {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_20,
        color: AppColors.black,
      );
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
        return AppLocale.of().removeFromCart.toUpperCase();
      } else {
        return AppLocale.of().addToCart;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return AppLocale.of().removeFromCart.toUpperCase();
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return AppLocale.of().addToCart.toUpperCase();
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.song.isInCart) {
      return AppLocale.of().removeFromCart.toUpperCase();
    } else {
      return AppLocale.of().addToCart.toUpperCase();
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
