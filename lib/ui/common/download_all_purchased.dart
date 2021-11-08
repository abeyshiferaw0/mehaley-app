import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
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
            AppLocalizations.of(context)!.downAllPurchased,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: downloadAllSelected,
              // trackColor:
              //     MaterialStateProperty.all<Color>(AppColors.grey),
              activeColor: AppColors.darkGreen,
              activeTrackColor: AppColors.green.withOpacity(0.3),
              inactiveTrackColor: AppColors.grey,
              onChanged: (bool isSwitched) {},
            ),
          )
        ],
      ),
    );
  }
}
