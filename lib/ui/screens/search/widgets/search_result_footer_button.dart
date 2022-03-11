import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class SearchResultFooterButton extends StatelessWidget {
  const SearchResultFooterButton({
    Key? key,
    required this.text,
    required this.isForRecentItem,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final bool isForRecentItem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_8,
          horizontal: AppPadding.padding_12,
        ),
        child: Row(
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: ColorMapper.getBlack(),
                fontWeight: isForRecentItem ? FontWeight.w600 : FontWeight.w200,
                fontSize: isForRecentItem
                    ? AppFontSizes.font_size_12.sp
                    : AppFontSizes.font_size_12.sp,
              ),
            ),
            SizedBox(width: AppMargin.margin_8),
            Icon(
              FlutterRemix.arrow_right_line,
              color: ColorMapper.getGrey(),
              size: AppIconSizes.icon_size_12,
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
