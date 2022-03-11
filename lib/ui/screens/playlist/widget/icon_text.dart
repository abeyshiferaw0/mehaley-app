import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';

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
          color: ColorMapper.getBlack(),
        ),
        SizedBox(width: AppMargin.margin_4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12,
            color: ColorMapper.getDarkGrey(),
          ),
        ),
      ],
    );
  }
}
