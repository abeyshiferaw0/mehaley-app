import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: AppMargin.margin_6,
        top: AppMargin.margin_6,
      ),
      child: Image.asset(
        AppAssets.icAppIconWhite,
        height: AppIconSizes.icon_size_24,
        width: AppIconSizes.icon_size_24,
        fit: BoxFit.contain,
        color: AppColors.white.withOpacity(0.4),
      ),
    );
  }
}
