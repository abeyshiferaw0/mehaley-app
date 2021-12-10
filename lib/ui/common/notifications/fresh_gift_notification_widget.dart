import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/wallet_gift.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/date_util_extention.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:sizer/sizer.dart';

class FreshGiftNotificationWidget extends StatelessWidget {
  const FreshGiftNotificationWidget({
    Key? key,
    required this.freshWalletGift,
  }) : super(key: key);

  final WalletGift freshWalletGift;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          children: [
            Expanded(
              flex: 30,
              child: Lottie.asset(
                AppAssets.notificationGiftLottie,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          AppLocale.of().giftReceived.toUpperCase(),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_10.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            color: ColorUtil.changeColorSaturation(
                              AppColors.green,
                              0.2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppMargin.margin_8),
                      Text(
                        '${DateFormat('MMM dd, yyyy').format(freshWalletGift.dateCreated).toString()}',
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_8.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Text(
                    L10nUtil.translateLocale(
                      freshWalletGift.subTitle,
                      context,
                    ),
                    maxLines: 3,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: AppFontSizes.font_size_8.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.txtGrey,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${AppLocale.of().giftFrom.toUpperCase()}  ',
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_8.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.txtGrey,
                          ),
                          children: [
                            TextSpan(
                              text: L10nUtil.translateLocale(
                                freshWalletGift.source,
                                context,
                              ).toUpperCase(),
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_8.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: AppLocale.of().amount.toUpperCase(),
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_8.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.txtGrey,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '  ${freshWalletGift.walletHistory.amount.parsePriceAmount()} ${AppLocale.of().birr}'
                                      .toUpperCase(),
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_8.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
