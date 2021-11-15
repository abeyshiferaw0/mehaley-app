import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';

class PlayShuffleLgBtnWidget extends StatelessWidget {
  final VoidCallback onTap;

  const PlayShuffleLgBtnWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: AppIconSizes.icon_size_30,
            backgroundColor: AppColors.darkOrange,
            child: Icon(
              Icons.play_arrow_sharp,
              color: AppColors.black,
              size: AppIconSizes.icon_size_36,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: AppColors.white.withOpacity(0.2),
                    spreadRadius: AppCardElevations.elevation_6,
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                PhosphorIcons.shuffle,
                color: AppColors.darkOrange,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
