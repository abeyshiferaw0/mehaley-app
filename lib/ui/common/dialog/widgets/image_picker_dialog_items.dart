import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class ImagePickerDialogItems extends StatelessWidget {
  const ImagePickerDialogItems({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_16,
          vertical: AppPadding.padding_16,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.black,
              size: AppIconSizes.icon_size_24,
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
