import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class FeaturedSongsItem extends StatelessWidget {
  const FeaturedSongsItem(
      {Key? key,
      required this.song,
      required this.onTap,
      required this.onSmallPlayButtonTap})
      : super(key: key);

  final Song song;
  final VoidCallback onTap;
  final VoidCallback onSmallPlayButtonTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          right: AppPadding.padding_16,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: double.infinity,
            color: AppColors.lightGrey,
            child: Row(
              children: [
                buildImageExpanded(),
                buildDetailsExpanded(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded buildDetailsExpanded(context) {
    return Expanded(
      flex: 75,
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(AppPadding.padding_8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${L10nUtil.translateLocale(song.songName, context)} - ${PagesUtilFunctions.getArtistsNames(song.artistsName, context)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSizes.font_size_10.sp,
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_4,
                    ),
                    SmallTextPriceWidget(
                      priceEtb: song.priceEtb,
                      priceUsd: song.priceDollar,
                      isDiscountAvailable: song.isDiscountAvailable,
                      discountPercentage: song.discountPercentage,
                      isFree: song.isFree,
                      isPurchased: song.isBought,
                    )
                  ],
                ),
              ),
            ),
            AppBouncingButton(
              onTap: onSmallPlayButtonTap,
              child: Container(
                padding: EdgeInsets.all(AppPadding.padding_16),
                child: Center(
                  child: Container(
                    child: Icon(
                      FlutterRemix.play_circle_fill,
                      size: AppIconSizes.icon_size_48,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded buildImageExpanded() {
    return Expanded(
      flex: 25,
      child: CachedNetworkImage(
        imageUrl: AppApi.baseUrl + song.albumArt.imageSmallPath,
        imageBuilder: (context, imageProvider) => Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppIconWidget(),
          ],
        ),
        placeholder: (context, url) => buildItemsImagePlaceHolder(),
        errorWidget: (context, url, error) => buildItemsImagePlaceHolder(),
      ),
    );
  }

  Container buildItemsImagePlaceHolder() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorUtil.darken(AppColors.lightGrey, 0.04),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Icon(
            FlutterRemix.music_2_line,
            color: AppColors.grey.withOpacity(0.5),
            size: constraint.biggest.height / 2,
          );
        },
      ),
    );
  }
}
