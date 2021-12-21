import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class MainAppBar extends StatelessWidget {
  final Widget? leading;

  const MainAppBar({Key? key, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: AppMargin.margin_16,
        ),
        leading != null
            ? leading!
            : Image.asset(
                AppAssets.icAppWordIcon,
                height: AppIconSizes.icon_size_20,
                fit: BoxFit.cover,
              ),
        Expanded(
          child: SizedBox(),
        ),
        AppBouncingButton(
          onTap: () {
            PagesUtilFunctions.goToWalletPage(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.padding_8),
            child: Icon(
              FlutterRemix.wallet_3_line,
              size: AppIconSizes.icon_size_24,
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(
          width: AppPadding.padding_16,
        ),
        AppBouncingButton(
          onTap: () {
            Navigator.pushNamed(context, AppRouterPaths.settingRoute);
          },
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.padding_8),
            child: Icon(
              FlutterRemix.settings_4_line,
              size: AppIconSizes.icon_size_24,
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(
          width: AppPadding.padding_4,
        ),
      ],
    );
  }
}
