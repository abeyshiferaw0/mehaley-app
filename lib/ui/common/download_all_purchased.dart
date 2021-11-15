import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class DownloadAllPurchased extends StatelessWidget {
  DownloadAllPurchased({Key? key, required this.downloadAllSelected})
      : super(key: key);

  final bool downloadAllSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocale.of().downAllPurchased,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: downloadAllSelected,
              // trackColor:
              //     MaterialStateProperty.all<Color>(AppColors.grey),
              activeColor: AppColors.darkOrange,
              activeTrackColor: AppColors.orange.withOpacity(0.3),
              inactiveTrackColor: AppColors.grey,
              onChanged: (bool isSwitched) {},
            ),
          )
        ],
      ),
    );
  }
}
