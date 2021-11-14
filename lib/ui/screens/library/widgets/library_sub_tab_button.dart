import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';import 'package:elf_play/app_language/app_locale.dart';

class LibraryPageSubTabButton extends StatelessWidget {
  const LibraryPageSubTabButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.isSelected,
    required this.hasLeftMargin,
    this.prefixIcon,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final bool isSelected;
  final bool hasLeftMargin;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: hasLeftMargin ? AppMargin.margin_12 : 0),
      child: AppBouncingButton(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_18,
            vertical: AppPadding.padding_6,
          ),
          margin: EdgeInsets.symmetric(vertical: AppMargin.margin_16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              color: isSelected
                  ? AppColors.transparent
                  : AppColors.white.withOpacity(0.2),
            ),
            color: isSelected ? AppColors.darkGreen : AppColors.transparent,
          ),
          child: Row(
            children: [
              prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: AppPadding.padding_8),
                      child: Icon(
                        prefixIcon,
                        color: AppColors.white,
                        size: AppIconSizes.icon_size_16,
                      ),
                    )
                  : SizedBox(),
              Text(
                text,
                style: TextStyle(
                  fontSize: (AppFontSizes.font_size_8 + 1).sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
