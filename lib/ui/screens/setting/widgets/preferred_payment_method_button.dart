import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class SettingLargeButton extends StatelessWidget {
  const SettingLargeButton({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      shrinkRatio: 6,
      child: Container(
        margin: EdgeInsets.only(top: AppMargin.margin_32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.txtGrey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Icon(
              PhosphorIcons.caret_right_light,
              color: AppColors.lightGrey,
              size: AppIconSizes.icon_size_24,
            ),
          ],
        ),
      ),
    );
  }
}
