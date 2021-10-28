import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ItemHomeUserLib extends StatelessWidget {
  final String text;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  ItemHomeUserLib({
    required this.text,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        child: AppCard(
          child: Row(
            children: [
              Expanded(
                flex: 35,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            color: AppColors.black.withOpacity(0.2),
                            blurRadius: 2,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.white,
                        size: AppIconSizes.icon_size_24,
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: AppColors.completelyBlack.withOpacity(0.3),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 65,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_8,
                  ),
                  color: AppColors.darkGrey.withOpacity(0.9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppFontSizes.font_size_10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.OTHER);
  }
}
