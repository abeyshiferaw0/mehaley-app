import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';

import 'app_bouncing_button.dart';

class AppTopHeaderWithIcon extends StatelessWidget {
  const AppTopHeaderWithIcon({Key? key, this.isForNewAppVersionDialog = false})
      : super(key: key);

  final bool isForNewAppVersionDialog;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_8,
        horizontal: AppPadding.padding_16,
      ),
      decoration: BoxDecoration(
        border: !isForNewAppVersionDialog
            ? Border(
                bottom: BorderSide(
                  width: 1,
                  color: AppColors.lightGrey,
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppIconSizes.icon_size_16,
              ),
              child: Image.asset(
                AppAssets.icAppWordIcon,
                height: isForNewAppVersionDialog
                    ? AppIconSizes.icon_size_20
                    : AppIconSizes.icon_size_16,
                fit: BoxFit.contain,
              ),
            ),
          ),
          AppBouncingButton(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.padding_4),
              child: Container(
                child: Icon(
                  FlutterRemix.close_line,
                  color: AppColors.black,
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
