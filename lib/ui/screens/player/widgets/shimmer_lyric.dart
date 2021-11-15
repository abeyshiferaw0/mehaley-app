import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/shimmer_item.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmerLyric extends StatelessWidget {
  const ShimmerLyric({Key? key, required this.dominantColor}) : super(key: key);

  final Color dominantColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppValues.lyricPlayerHeight,
      decoration: BoxDecoration(
        color: dominantColor,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(AppPadding.padding_14),
      margin: EdgeInsets.all(AppMargin.margin_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.of().lyrics.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          Shimmer.fromColors(
            highlightColor: ColorUtil.darken(dominantColor, 0.1),
            baseColor: ColorUtil.darken(dominantColor, 0.15),
            direction: ShimmerDirection.ltr,
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppMargin.margin_32),
                    ShimmerItem(
                      width: double.infinity,
                      height: 15,
                      radius: 15.0,
                    ),
                    SizedBox(height: AppMargin.margin_16),
                    ShimmerItem(
                      width: 150,
                      height: 15,
                      radius: 15.0,
                    ),
                    SizedBox(height: AppMargin.margin_16),
                    ShimmerItem(
                      width: double.infinity,
                      height: 15,
                      radius: 15.0,
                    ),
                    SizedBox(height: AppMargin.margin_16),
                    ShimmerItem(
                      width: 165,
                      height: 15,
                      radius: 15.0,
                    ),
                    SizedBox(height: AppMargin.margin_48),
                    ShimmerItem(
                      width: double.infinity,
                      height: 15,
                      radius: 15.0,
                    ),
                    SizedBox(height: AppMargin.margin_16),
                    ShimmerItem(
                      width: double.infinity,
                      height: 15,
                      radius: 15.0,
                    ),
                    SizedBox(height: AppMargin.margin_16),
                    ShimmerItem(
                      width: double.infinity,
                      height: 15,
                      radius: 15.0,
                    ),
                    SizedBox(height: AppMargin.margin_16),
                    ShimmerItem(
                      width: double.infinity,
                      height: 15,
                      radius: 15.0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
