import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class WalletPayWithCarousel extends StatefulWidget {
  const WalletPayWithCarousel({Key? key}) : super(key: key);

  @override
  State<WalletPayWithCarousel> createState() => _WalletPayWithCarouselState();
}

class _WalletPayWithCarouselState extends State<WalletPayWithCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pagesBgColor,
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_16,
            ),
            child: Row(
              children: [
                Text(
                  "Powered by",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(width: AppMargin.margin_4),
                Image.asset(
                  AppAssets.icWeBirr,
                  width: AppIconSizes.icon_size_32,
                  height: AppIconSizes.icon_size_32,
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: AppMargin.margin_16,
                ),
                buildPaymentMethodInfo(),
                SizedBox(
                  width: AppMargin.margin_24,
                ),
                buildPaymentMethodInfo(),
                SizedBox(
                  width: AppMargin.margin_24,
                ),
                buildPaymentMethodInfo(),
                SizedBox(
                  width: AppMargin.margin_24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethodInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: AppIconSizes.icon_size_48,
          height: AppIconSizes.icon_size_48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200.0),
            color: AppColors.white,
          ),
          child: Center(
            child: Image.asset(
              AppAssets.icCbeBirr,
              width: AppIconSizes.icon_size_32,
              height: AppIconSizes.icon_size_32,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          width: AppMargin.margin_16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CBE Birr".toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_4,
            ),
            Text(
              "How to pay with\nCbe Birr?",
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
