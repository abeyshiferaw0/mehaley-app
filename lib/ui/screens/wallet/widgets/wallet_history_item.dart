import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class WalletHistoryItem extends StatelessWidget {
  const WalletHistoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.padding_16),
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.completelyBlack.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.completelyBlack.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  "Wallet Recharged",
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppMargin.margin_4),
                Text(
                  "2 Feb 2021",
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
          Text(
            "+200",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}
