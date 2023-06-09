import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class PlaylistsRefreshingWidget extends StatelessWidget {
  const PlaylistsRefreshingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: ColorMapper.getLightGrey(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorMapper.getWhite().withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 6,
              offset: Offset(0, 0),
            )
          ],
        ),
        margin: EdgeInsets.only(bottom: AppMargin.margin_24),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_28,
          vertical: AppPadding.padding_8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppIconSizes.icon_size_12,
              height: AppIconSizes.icon_size_12,
              child: CircularProgressIndicator(
                color: ColorMapper.getDarkOrange().withOpacity(0.5),
                strokeWidth: 1,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Text(
              AppLocale.of().refreshing,
              style: TextStyle(
                color: ColorMapper.getTxtGrey(),
                fontSize: AppFontSizes.font_size_8.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
