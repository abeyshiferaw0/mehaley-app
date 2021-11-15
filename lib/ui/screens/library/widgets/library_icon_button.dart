import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';

class LibraryIconButton extends StatelessWidget {
  const LibraryIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppPadding.padding_8),
        child: Icon(
          icon,
          color: iconColor,
          size: AppIconSizes.icon_size_24,
        ),
      ),
    );
  }
}
