import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppGradients {
  RadialGradient getHomeHeaderGradient(Color color) {
    return RadialGradient(
      radius: 1,
      colors: [
        ColorUtil.darken(color, 0.1),
        ColorUtil.darken(color, 0.1),
        AppColors.black
      ],
      center: Alignment(-0.5, -1.8),
      focal: Alignment(-2, -2),
    );
  }

  LinearGradient getSearchHeaderGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color, AppColors.black],
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
      colors: [color.withOpacity(1), AppColors.black],
    );
  }

  getCategoryFilterGradient(Color color) {
    return LinearGradient(
      colors: [AppColors.black.withOpacity(0.5), AppColors.black],
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
        ColorUtil.darken(color, 0.0),
        ColorUtil.darken(color, 0.9),
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
        AppColors.black,
      ],
    );
  }

  getAlbumPageBgGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        AppColors.black,
      ],
    );
  }

  getPlaylistHeaderGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        AppColors.black,
      ],
    );
  }

  getArtistHeaderGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.black.withOpacity(0.5),
        AppColors.black,
        //Colors.black12.withOpacity(0.9),
      ],
    );
  }

  getMenuGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.completelyBlack.withOpacity(0.7),
        AppColors.completelyBlack,
      ],
    );
  }

  getSignInPageGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.completelyBlack.withOpacity(0.7),
        AppColors.completelyBlack.withOpacity(0.9),
        AppColors.completelyBlack,
      ],
    );
  }

  getCountryDialogGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.completelyBlack.withOpacity(0.7),
        AppColors.completelyBlack.withOpacity(0.8),
      ],
    );
  }

  getProfilePageGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorUtil.darken(color, 0.1),
        AppColors.black,
      ],
    );
  }
}
