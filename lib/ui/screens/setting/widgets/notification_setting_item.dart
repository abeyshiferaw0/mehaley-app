import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
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
        onSwitched();
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
                activeColor: AppColors.darkGreen,
                activeTrackColor: AppColors.green.withOpacity(0.3),
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
                color: AppColors.lightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
