import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/color_util.dart';

class AppGradients {
  RadialGradient getHomeHeaderGradient(Color color) {
    return RadialGradient(
      radius: 1,
      colors: [
        ColorUtil.darken(color, 0.1),
        ColorUtil.darken(color, 0.1),
        AppColors.white
      ],
      center: Alignment(-0.5, -1.8),
      focal: Alignment(-2, -2),
    );
  }

  LinearGradient getSearchHeaderGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color, AppColors.white],
    );
  }

  getCategoryHeaderGradient(Color color) {
    // return RadialGradient(
    //   radius: 1,
    //   colors: [color.withOpacity(1), AppColors.black],
    //   center: Alignment(-0.5, -1),
    // );
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withOpacity(1), AppColors.white],
    );
  }

  getCategoryFilterGradient(Color color) {
    return LinearGradient(
      colors: [AppColors.white.withOpacity(0.5), AppColors.white],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  LinearGradient getPlayerBgGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      //stops: [0.2, 0.7],
      colors: [
        ColorUtil.darken(ColorUtil.changeColorSaturation(color, 0.5), 0.05),
        ColorUtil.darken(ColorUtil.changeColorSaturation(color, 0.8), 0.1),
        //ColorUtil.changeColorSaturation(color, 0.9),
        //Colors.black12.withOpacity(0.9),
      ],
    );
  }

  getPlayerVideoBgGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorUtil.darken(color, 0.5).withOpacity(0.5),
        AppColors.white,
      ],
    );
  }

  getAlbumPageBgGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        AppColors.white,
      ],
    );
  }

  getPlaylistHeaderGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        AppColors.white,
      ],
    );
  }

  getArtistHeaderGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.white.withOpacity(0.5),
        AppColors.white,
        //Colors.black12.withOpacity(0.9),
      ],
    );
  }

  getMenuGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.white.withOpacity(0.7),
        AppColors.white,
      ],
    );
  }

  getSignInPageGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.completelyBlack.withOpacity(0.2),
        AppColors.completelyBlack.withOpacity(0.9),
      ],
    );
  }

  getCountryDialogGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.white.withOpacity(0.7),
        AppColors.white.withOpacity(0.8),
      ],
    );
  }

  getProfilePageGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        AppColors.white,
      ],
    );
  }

  getUserPlaylistHeaderGradient(Color dominantColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        dominantColor,
        AppColors.white,
      ],
    );
  }

  static getOfflineLibraryGradient() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        AppColors.orange1,
        AppColors.orange2,
      ],
    );
  }
}
