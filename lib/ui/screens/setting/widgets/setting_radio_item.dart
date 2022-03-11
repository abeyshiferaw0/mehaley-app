import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
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
                    color: ColorMapper.getBlack(),
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
                    color: ColorMapper.getTxtGrey(),
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
            //     MaterialStateProperty.all<Color>(ColorMapper.getGrey()),
            activeColor: ColorMapper.getDarkOrange(),
            activeTrackColor: ColorMapper.getOrange().withOpacity(0.3),
            inactiveTrackColor: ColorMapper.getGrey(),
            onChanged: onSwitched,
          )
        ],
      ),
    );
  }
}
