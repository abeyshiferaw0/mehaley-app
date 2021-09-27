import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

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
            backgroundColor: AppColors.darkGreen,
            child: Icon(
              Icons.play_arrow_sharp,
              color: AppColors.white,
              size: AppIconSizes.icon_size_36,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: AppColors.black.withOpacity(0.2),
                    spreadRadius: AppCardElevations.elevation_6,
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                PhosphorIcons.shuffle,
                color: AppColors.darkGreen,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
