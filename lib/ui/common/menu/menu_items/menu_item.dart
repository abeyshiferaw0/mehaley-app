import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.title,
    required this.onTap,
    required this.icon,
    required this.hasTopMargin,
    required this.isDisabled,
    required this.iconColor,
    this.leadingWidget,
    this.hasLeadingWidget,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final IconData icon;
  final bool hasTopMargin;
  final bool isDisabled;
  final Color iconColor;
  final Widget? leadingWidget;
  final bool? hasLeadingWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //ADD TO MARGIN IF WANTED
        hasTopMargin ? SizedBox(height: AppMargin.margin_12) : SizedBox(),
        AppBouncingButton(
          onTap: !isDisabled ? onTap : () {},
          disableBouncing: isDisabled,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppPadding.padding_8,
            ),
            child: Row(
              children: [
                getLeading(),
                SizedBox(width: AppMargin.margin_20),
                Text(
                  title,
                  style: TextStyle(
                    color: !isDisabled
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.4),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getLeading() {
    if (hasLeadingWidget != null && leadingWidget != null) {
      if (hasLeadingWidget!) {
        return leadingWidget!;
      }
    }
    return Icon(
      icon,
      size: AppIconSizes.icon_size_24,
      color: iconColor,
    );
  }
}
