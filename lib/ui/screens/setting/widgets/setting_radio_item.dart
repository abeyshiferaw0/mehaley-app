import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class SettingRadioItem extends StatelessWidget {
  const SettingRadioItem({
    Key? key,
    required this.isEnabled,
    required this.onSwitched,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final bool isEnabled;
  final Function(bool value) onSwitched;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppMargin.margin_32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_8,
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.txtGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Switch(
            value: isEnabled,
            // trackColor:
            //     MaterialStateProperty.all<Color>(AppColors.grey),
            activeColor: AppColors.darkOrange,
            activeTrackColor: AppColors.orange.withOpacity(0.3),
            inactiveTrackColor: AppColors.grey,
            onChanged: onSwitched,
          )
        ],
      ),
    );
  }
}
