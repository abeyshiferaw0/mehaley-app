import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/wallet_history.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class WalletHistoryItem extends StatelessWidget {
  const WalletHistoryItem({Key? key, required this.walletHistory})
      : super(key: key);

  final WalletHistory walletHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.padding_16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.completelyBlack.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Icon(
          //   FlutterRemix.question_line,
          //   size: AppIconSizes.icon_size_20,
          //   color: AppColors.darkGrey,
          // ),
          // SizedBox(width: AppMargin.margin_16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PagesUtilFunctions.getWalletHistoryAction(walletHistory),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppMargin.margin_4),
                Text(
                  DateFormat.yMMMd().format(walletHistory.dateCreated),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.txtGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppMargin.margin_12),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: PagesUtilFunctions.getWalletHistoryPrice(walletHistory),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
                color: PagesUtilFunctions.getWalletHistoryPriceColor(
                  walletHistory,
                ),
              ),
              children: [
                TextSpan(
                  text: ' ${AppLocale.of().birr.toUpperCase()}',
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_6.sp,
                    fontWeight: FontWeight.w400,
                    color: PagesUtilFunctions.getWalletHistoryPriceColor(
                      walletHistory,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
