import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/date_util_extention.dart';
import 'package:sizer/sizer.dart';

class CheckedOutItemWidget extends StatelessWidget {
  const CheckedOutItemWidget({
    Key? key,
    required this.cartTotalPrice,
  }) : super(key: key);

  final double cartTotalPrice;

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
              radius: 6.0,
              withShadow: false,
              child: Container(
                width: AppValues.previewDialogSongItemSize,
                height: AppValues.previewDialogSongItemSize,
                color: AppColors.pagesBgColor,
                padding: EdgeInsets.all(AppPadding.padding_4),
                child: Lottie.asset(
                  AppAssets.cartStatusLottie,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocale.of().cartCheckedOut,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppFontSizes.font_size_14,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Text(
                    AppLocale.of().cartCheckedOutMsg,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_8.sp,
                      color: AppColors.txtGrey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_4,
                  ),
                  Text(
                    '${cartTotalPrice.parsePriceAmount()} ${AppLocale().birr}',
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
