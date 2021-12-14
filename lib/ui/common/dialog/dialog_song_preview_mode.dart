import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:marquee/marquee.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/cart_buttons/dialog_song_preview_cart_button.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../app_card.dart';

class DialogSongPreviewMode extends StatelessWidget {
  final Song song;
  final bool isForDownload;
  final bool isForPlaying;
  final VoidCallback onBuyButtonClicked;

  const DialogSongPreviewMode({
    Key? key,
    required this.song,
    required this.isForDownload,
    required this.isForPlaying,
    required this.onBuyButtonClicked,
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
              buildPreviewTitle(context),
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

  Padding buildPreviewTitle(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppMargin.margin_16),
      child: Text(
        isForPlaying
            ? AppLocale.of().previewMode.toUpperCase()
            : isForDownload
                ? AppLocale.of().buyMezmur.toUpperCase()
                : '',
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
                imageUrl: AppApi.baseUrl + song.albumArt.imageMediumPath,
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
                    color: AppColors.txtGrey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_4,
                ),
                Text(
                  '${song.priceEtb.parsePriceAmount()} ${AppLocale().birr}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    color: AppColors.darkOrange,
                    fontWeight: FontWeight.w400,
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
            isForPlaying
                ? AppLocale.of().uAreListingToPreviewDesc
                : isForDownload
                    ? AppLocale.of().buyMezmurToListenOffline
                    : '',
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
            onTap: () {
              Navigator.pop(context);
              onBuyButtonClicked();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_32,
                vertical: AppPadding.padding_6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.orange,
              ),
              child: Text(
                AppLocale.of().buyMezmur.toUpperCase(),
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
            child: Image.asset(
              AppAssets.icAppFullIcon,
              width: AppIconSizes.icon_size_48,
              fit: BoxFit.contain,
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
                  FlutterRemix.close_line,
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
