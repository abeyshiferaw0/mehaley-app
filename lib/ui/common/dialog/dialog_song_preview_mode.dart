import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/material.dart';

class DialogSongPreviewMode extends StatelessWidget {
  final Color dominantColor;

  DialogSongPreviewMode({required this.dominantColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: AppMargin.margin_52),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_14,
        vertical: AppPadding.padding_16,
      ),
      decoration: BoxDecoration(
        gradient: AppGradients().getPlayerVideoBgGradient(dominantColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppValues.previewModeDialogAppIconSize,
                height: AppValues.previewModeDialogAppIconSize,
                padding: EdgeInsets.all(AppPadding.padding_12),
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppValues.previewModeDialogAppIconSize),
                  ),
                ),
                child: AppIconWidget(),
              ),
              SizedBox(width: AppMargin.margin_8),
              Text(
                "ELF PLAY",
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_24,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: AppMargin.margin_20),
          Text(
            "Preview Mode",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_20,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppMargin.margin_32),
          Text(
            "You are listening to the preview version, buy the music to listen to full version",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_16,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: AppMargin.margin_38),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundButton(
                text: "BUY SONG",
                color: AppColors.darkGreen,
                textColor: AppColors.white,
              ),
              RoundButton(
                text: "ADD TO CART",
                color: AppColors.white,
                textColor: AppColors.darkGrey,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;

  const RoundButton(
      {required this.color, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_18,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.OTHER);
}
