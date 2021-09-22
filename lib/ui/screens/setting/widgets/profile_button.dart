import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        Navigator.pushNamed(context, AppRouterPaths.profileRoute);
      },
      shrinkRatio: 6,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.green,
            radius: AppIconSizes.icon_size_36,
            child: Text(
              "A",
              style: TextStyle(
                fontSize: AppFontSizes.font_size_24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Abey shi",
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_4,
              ),
              Text(
                "View profile",
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.txtGrey,
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Icon(
            PhosphorIcons.caret_right_light,
            color: AppColors.lightGrey,
            size: AppIconSizes.icon_size_24,
          ),
        ],
      ),
    );
  }
}
