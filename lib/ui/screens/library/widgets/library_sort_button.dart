import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class LibrarySortButton extends StatelessWidget {
  const LibrarySortButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            isSelected
                ? Icon(
                    FlutterRemix.check_line,
                    color: AppColors.darkOrange,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
