import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class NotificationSettingItem extends StatelessWidget {
  const NotificationSettingItem({
    Key? key,
    required this.isEnabled,
    required this.text,
    required this.onSwitched,
  }) : super(key: key);

  final bool isEnabled;
  final String text;
  final VoidCallback onSwitched;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        PagesUtilFunctions.checkNotificationPermission(
            context: context, onSwitched: onSwitched);
      },
      shrinkRatio: 2,
      child: Container(
        // padding: EdgeInsets.symmetric(t: AppMargin.margin_8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: isEnabled,
                activeColor: AppColors.darkOrange,
                activeTrackColor: AppColors.orange.withOpacity(0.3),
                inactiveTrackColor: AppColors.grey,
                onChanged: (val) {
                  onSwitched();
                },
              ),
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
