import 'package:auto_size_text/auto_size_text.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

SnackBar buildAppSnackBar({
  required Color bgColor,
  required String msg,
  required Color txtColor,
  bool isFloating = true,
}) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          msg,
          maxFontSize: AppFontSizes.font_size_14,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: txtColor,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
    duration: Duration(seconds: 3),
    margin: isFloating
        ? EdgeInsets.symmetric(
            horizontal: AppMargin.margin_16,
            vertical: AppMargin.margin_16,
          )
        : null,
    // padding: EdgeInsets.symmetric(vertical: AppPadding.padding_2),
    elevation: 12,
    behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(isFloating ? 8 : 0),
    ),
    backgroundColor: bgColor,
  );
}

SnackBar buildDownloadSuccessSnackBar({
  required Color bgColor,
  required String msg,
  required Color txtColor,
  bool isFloating = true,
}) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          PhosphorIcons.check_circle_fill,
          color: AppColors.green,
          size: AppIconSizes.icon_size_24,
        ),
        SizedBox(
          width: AppMargin.margin_16,
        ),
        AutoSizeText(
          msg,
          maxFontSize: AppFontSizes.font_size_14,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: txtColor,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
    duration: Duration(seconds: 4),
    margin: isFloating
        ? EdgeInsets.symmetric(
            horizontal: AppMargin.margin_16,
            vertical: AppMargin.margin_16,
          )
        : null,
    // padding: EdgeInsets.symmetric(vertical: AppPadding.padding_2),
    elevation: 12,
    behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(isFloating ? 8 : 0),
    ),
    backgroundColor: bgColor,
  );
}
