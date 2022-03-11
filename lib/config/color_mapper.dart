import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';

class ColorMapper {
  static Color getWhite({bool isForDialog = false}) {
    if (isForDialog) return AppColors.white;
    return AppEnv.isMehaleye() ? AppColors.white : AppColors.black;
  }

  static Color getLightGrey({bool isForDialog = false}) {
    if (isForDialog) return AppColors.lightGrey;
    return AppEnv.isMehaleye() ? AppColors.lightGrey : AppColors.darkGrey;
  }

  static Color getPagesBgColor() {
    return AppEnv.isMehaleye() ? AppColors.pagesBgColor : AppColors.completelyBlack;
  }

  static Color getPlaceholderIconColor() {
    return AppEnv.isMehaleye()
        ? AppColors.placeholderIconColor
        : AppColors.darkGrey;
  }

  static Color getDarkGrey({bool isForDialog = false}) {
    if (isForDialog) return AppColors.lightGrey;
    return AppEnv.isMehaleye() ? AppColors.darkGrey : AppColors.lightGrey;
  }

  static Color getTxtGrey({bool isForDialog = false}) {
    if (isForDialog) return AppColors.lightGrey;
    return AppEnv.isMehaleye() ? AppColors.txtGrey : AppColors.lightGrey;
  }

  static Color getGrey() {
    return AppEnv.isMehaleye() ? AppColors.grey : AppColors.grey;
  }

  static Color getBlack({bool isForDialog = false}) {
    if (isForDialog) return AppColors.white;
    return AppEnv.isMehaleye() ? AppColors.black : AppColors.white;
  }

  static Color getCompletelyBlack() {
    return AppEnv.isMehaleye() ? AppColors.completelyBlack : AppColors.white;
  }

  /////
  static Color getOrange1() {
    return AppEnv.isMehaleye() ? AppColors.orange1 : AppColors.green1;
  }

  static Color getOrange2() {
    return AppEnv.isMehaleye() ? AppColors.orange2 : AppColors.green2;
  }

  static Color getOrange() {
    return AppEnv.isMehaleye() ? AppColors.orange : AppColors.green;
  }

  static Color getDarkOrange() {
    return AppEnv.isMehaleye() ? AppColors.darkOrange : AppColors.darkGreen;
  }
}
