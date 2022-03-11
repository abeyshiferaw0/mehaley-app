import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
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
              color: ColorMapper.getDarkGrey(),
              fontWeight: FontWeight.w600,
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: downloadAllSelected,
              // trackColor:
              //     MaterialStateProperty.all<Color>(ColorMapper.getGrey()),
              activeColor: ColorMapper.getDarkOrange(),
              activeTrackColor: ColorMapper.getOrange().withOpacity(0.3),
              inactiveTrackColor: ColorMapper.getGrey(),
              onChanged: (bool isSwitched) {},
            ),
          )
        ],
      ),
    );
  }
}
