import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/shimmer_item.dart';
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
        color: ColorMapper.getWhite(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(AppPadding.padding_14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.of().lyrics.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: ColorMapper.getBlack(),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: AppMargin.margin_8),
          Divider(
            color: ColorMapper.getLightGrey(),
          ),
          Shimmer.fromColors(
            highlightColor: ColorMapper.getLightGrey().withOpacity(0.5),
            baseColor: ColorMapper.getLightGrey(),
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
