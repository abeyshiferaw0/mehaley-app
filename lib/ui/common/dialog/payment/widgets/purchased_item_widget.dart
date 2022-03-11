import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:sizer/sizer.dart';

class PurchasedItemWidget extends StatelessWidget {
  const PurchasedItemWidget(
      {Key? key,
      required this.itemImageUrl,
      required this.itemTitle,
      required this.itemSubTitle,
      required this.itemPrice})
      : super(key: key);

  final String itemImageUrl;
  final String itemTitle;
  final String itemSubTitle;
  final double itemPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_24,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppCard(
              radius: 4.0,
              withShadow: false,
              child: CachedNetworkImage(
                width: AppValues.previewDialogSongItemSize,
                height: AppValues.previewDialogSongItemSize,
                fit: BoxFit.cover,
                imageUrl: itemImageUrl,
                placeholder: (context, url) => buildImagePlaceHolder(),
                errorWidget: (context, url, e) => buildImagePlaceHolder(),
              ),
            ),
            SizedBox(
              width: AppMargin.margin_8,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    child: AutoSizeText(
                      itemTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSizes.font_size_14,
                        color: ColorMapper.getBlack(),
                      ),
                      maxLines: 1,
                      minFontSize: AppFontSizes.font_size_12,
                      maxFontSize: AppFontSizes.font_size_14,
                      overflowReplacement: Marquee(
                        text: itemTitle,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_14,
                          fontWeight: FontWeight.w600,
                          color: ColorMapper.getBlack(),
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
                    itemSubTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      color: ColorMapper.getTxtGrey(),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_4,
                  ),
                  Text(
                    '${itemPrice.parsePriceAmount()} ${AppLocale().birr}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      color: ColorMapper.getDarkOrange(),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
