import 'package:flutter/material.dart';

class AutoDownloadRadio extends StatelessWidget {
  AutoDownloadRadio({Key? key, required this.downloadAllSelected})
      : super(key: key);

  final bool downloadAllSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    // return Container(
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(
    //         AppLocale.of().autoDownload,
    //         style: TextStyle(
    //           fontSize: AppFontSizes.font_size_12.sp,
    //           color: ColorMapper.getLightGrey(),
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //       Transform.scale(
    //         scale: 0.9,
    //         child: Switch(
    //           value: downloadAllSelected,
    //           // trackColor:
    //           //     MaterialStateProperty.all<Color>(ColorMapper.getGrey()),
    //           activeColor: AppColors.darkGreen,
    //           activeTrackColor: AppColors.green.withOpacity(0.3),
    //           inactiveTrackColor: ColorMapper.getGrey(),
    //           onChanged: (bool isSwitched) {},
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
