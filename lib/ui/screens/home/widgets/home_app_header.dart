import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hive/hive.dart';

class HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          color: AppColors.white,
          iconSize: AppIconSizes.icon_size_28,
          icon: Icon(PhosphorIcons.chat_teardrop_text_light),
          onPressed: () async {
            Box b = await Hive.openBox(AppValues.userBox);
            b.clear();
          },
        ),
        SizedBox(
          width: AppPadding.padding_16,
        ),
        AppBouncingButton(
          onTap: () {
            Navigator.pushNamed(context, AppRouterPaths.settingRoute);
          },
          child: Icon(
            PhosphorIcons.gear_light,
            size: AppIconSizes.icon_size_28,
            color: AppColors.white,
          ),
        ),
        SizedBox(
          width: AppPadding.padding_4,
        ),
      ],
    );
  }
}
