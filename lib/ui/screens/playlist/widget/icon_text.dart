import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppIconSizes.icon_size_16,
          color: AppColors.white,
        ),
        SizedBox(width: AppMargin.margin_4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12,
            color: AppColors.lightGrey,
          ),
        ),
      ],
    );
  }
}
