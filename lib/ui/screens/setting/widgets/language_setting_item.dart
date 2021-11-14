import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class LanguageSettingItem extends StatelessWidget {
  const LanguageSettingItem({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      shrinkRatio: 6,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppMargin.margin_8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.check_circle_fill,
              color: isSelected ? AppColors.darkGreen : AppColors.lightGrey,
              size: AppIconSizes.icon_size_20,
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w400,
                color: isSelected ? AppColors.darkGreen : AppColors.lightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
