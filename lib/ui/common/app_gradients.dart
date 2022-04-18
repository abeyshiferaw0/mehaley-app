import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/util/color_util.dart';

class AppGradients {
  RadialGradient getHomeHeaderGradient(Color color) {
    return RadialGradient(
      radius: 1,
      colors: [
        ColorUtil.darken(color, 0.1),
        ColorUtil.darken(color, 0.1),
        ColorMapper.getWhite()
      ],
      center: Alignment(-0.5, -1.8),
      focal: Alignment(-2, -2),
    );
  }

  LinearGradient getSearchHeaderGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color, ColorMapper.getWhite()],
    );
  }

  getCategoryHeaderGradient(Color color) {
    // return RadialGradient(
    //   radius: 1,
    //   colors: [color.withOpacity(1), ColorMapper.getBlack()],
    //   center: Alignment(-0.5, -1),
    // );
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withOpacity(1), ColorMapper.getWhite()],
    );
  }

  getCategoryFilterGradient(Color color) {
    return LinearGradient(
      colors: [ColorMapper.getWhite().withOpacity(0.5), ColorMapper.getWhite()],
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
        ColorUtil.darken(ColorUtil.changeColorSaturation(color, 0.4), 0.1),
        ColorUtil.darken(ColorUtil.changeColorSaturation(color, 0.7), 0.05),
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
        ColorMapper.getWhite(),
      ],
    );
  }

  getAlbumPageBgGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        ColorMapper.getWhite(),
      ],
    );
  }

  getPlaylistHeaderGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        ColorMapper.getWhite(),
      ],
    );
  }

  getArtistHeaderGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorMapper.getWhite().withOpacity(0.5),
        ColorMapper.getWhite(),
        //Colors.black12.withOpacity(0.9),
      ],
    );
  }

  getMenuGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorMapper.getWhite().withOpacity(0.7),
        ColorMapper.getWhite(),
      ],
    );
  }

  getSignInPageGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Platform.isAndroid
            ? ColorMapper.getCompletelyBlack().withOpacity(0.2)
            : ColorMapper.getCompletelyBlack().withOpacity(0.5),
        Platform.isAndroid
            ? ColorMapper.getCompletelyBlack().withOpacity(0.9)
            : ColorMapper.getCompletelyBlack(),
      ],
    );
  }

  getCountryDialogGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorMapper.getWhite().withOpacity(0.7),
        ColorMapper.getWhite().withOpacity(0.8),
      ],
    );
  }

  getProfilePageGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        ColorMapper.getWhite(),
      ],
    );
  }

  getUserPlaylistHeaderGradient(Color dominantColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        dominantColor,
        ColorMapper.getWhite(),
      ],
    );
  }

  static getOfflineLibraryGradient() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        ColorMapper.getOrange1(),
        ColorMapper.getOrange2(),
      ],
    );
  }

  static getTodayHolidayGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        ColorMapper.getOrange1(),
        ColorMapper.getOrange2(),
      ],
    );
  }

  static getArtistHeaderCovorGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorMapper.getCompletelyBlack().withOpacity(0.1),
        ColorMapper.getCompletelyBlack().withOpacity(0.5),
      ],
    );
  }

  static getSubscriptionOfferingsGradient(
      HexColor color1, HexColor color2, HexColor color3) {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        color1,
        color2,
        color3,
      ],
    );
  }

  static getSubscribeButtonGradient() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        ColorMapper.getOrange1(),
        ColorMapper.getOrange(),
        ColorMapper.getOrange2(),
      ],
    );
  }
}
