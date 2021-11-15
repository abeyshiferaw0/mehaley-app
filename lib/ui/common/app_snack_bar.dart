import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';

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
            vertical: AppMargin.margin_32,
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

SnackBar buildDownloadMsgSnackBar({
  required Color bgColor,
  required String msg,
  required Color txtColor,
  required Color iconColor,
  required IconData icon,
  bool isFloating = true,
}) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: AppIconSizes.icon_size_24,
        ),
        SizedBox(
          width: AppMargin.margin_16,
        ),
        Expanded(
          child: AutoSizeText(
            msg,
            maxFontSize: AppFontSizes.font_size_12,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: txtColor,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w400,
            ),
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
      borderRadius: BorderRadius.circular(isFloating ? 4 : 0),
    ),
    backgroundColor: bgColor,
  );
}
