import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/cart_buttons/dialog_song_preview_cart_button.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

import '../app_card.dart';

class DialogSongPreviewMode extends StatelessWidget {
  final Song song;
  final Color dominantColor;

  const DialogSongPreviewMode({
    Key? key,
    required this.dominantColor,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: ScreenUtil(context: context).getScreenWidth() * 0.8,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTopCard(context),
              buildPreviewTitle(),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              buildSongItem(context),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              buildCardActions(context),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildPreviewTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppMargin.margin_16),
      child: Text(
        "Preview mode".toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }

  Container buildSongItem(context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCard(
              radius: 4.0,
              child: CachedNetworkImage(
                width: AppValues.previewDialogSongItemSize,
                height: AppValues.previewDialogSongItemSize,
                fit: BoxFit.cover,
                imageUrl: AppApi.baseFileUrl + song.albumArt.imageMediumPath,
                placeholder: (context, url) => buildImagePlaceHolder(),
                errorWidget: (context, url, e) => buildImagePlaceHolder(),
              ),
            ),
            SizedBox(
              width: AppMargin.margin_8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                  child: AutoSizeText(
                    L10nUtil.translateLocale(song.songName, context),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppFontSizes.font_size_16,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    minFontSize: AppFontSizes.font_size_16,
                    maxFontSize: AppFontSizes.font_size_16,
                    overflowReplacement: Marquee(
                      text: L10nUtil.translateLocale(song.songName, context),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: AppPadding.padding_32,
                      velocity: 50.0,
                      pauseAfterRound: Duration(seconds: 2),
                      startPadding: AppPadding.padding_16,
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.easeIn,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                      showFadingOnlyWhenScrolling: false,
                      fadingEdgeEndFraction: 0.2,
                      fadingEdgeStartFraction: 0.2,
                    ),
                  ),
                ),
                Text(
                  PagesUtilFunctions.getArtistsNames(song.artistsName, context),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildCardActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_20,
      ),
      child: Column(
        children: [
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Text(
            "You are listing to a preview version, buy the mezmur to listen the full version",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_32,
          ),
          AppBouncingButton(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_32,
                vertical: AppPadding.padding_6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.green,
              ),
              child: Text(
                "BUY MEZMUR".toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          AppBouncingButton(
            onTap: () {},
            child: DialogSongPreviewCartButton(
              song: song,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_8,
          ),
        ],
      ),
    );
  }

  Container buildTopCard(context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_8,
        horizontal: AppPadding.padding_16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.lightGrey,
          ),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlutterLogo(
                  size: AppIconSizes.icon_size_24,
                ),
                SizedBox(
                  width: AppPadding.padding_8,
                ),
                Text(
                  "Elf play",
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AppBouncingButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.padding_4),
                child: Icon(
                  PhosphorIcons.x_light,
                  color: AppColors.black,
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
