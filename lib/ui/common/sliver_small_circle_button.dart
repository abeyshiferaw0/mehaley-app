import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/color_util.dart';

import 'app_bouncing_button.dart';

class SliverSmallCircleButton extends StatelessWidget {
  const SliverSmallCircleButton({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppPadding.padding_12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              color: ColorUtil.darken(AppColors.white, 0.1),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
