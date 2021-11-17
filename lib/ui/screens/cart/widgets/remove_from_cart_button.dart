import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class RemoveFromCartButton extends StatelessWidget {
  const RemoveFromCartButton(
      {Key? key, required this.onRemoveFromCart, required this.isWithText})
      : super(key: key);

  final VoidCallback onRemoveFromCart;
  final bool isWithText;

  @override
  Widget build(BuildContext context) {
    if (isWithText) {
      return buildWithText(context);
    } else {
      return buildWithOutText();
    }
  }

  AppBouncingButton buildWithText(context) {
    return AppBouncingButton(
      onTap: onRemoveFromCart,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.padding_8,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppPadding.padding_4),
              decoration: BoxDecoration(
                color: AppColors.darkOrange.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                FlutterRemix.close_line,
                color: AppColors.black,
                size: AppIconSizes.icon_size_12,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_6,
            ),
            Text(
              AppLocale.of().remove.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                color: AppColors.txtGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildWithOutText() {
    return Row(
      children: [
        SizedBox(
          width: AppMargin.margin_12,
        ),
        AppBouncingButton(
          onTap: onRemoveFromCart,
          child: Container(
            padding: EdgeInsets.all(AppPadding.padding_4),
            decoration: BoxDecoration(
              color: AppColors.darkOrange.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              FlutterRemix.close_line,
              color: AppColors.black,
              size: AppIconSizes.icon_size_12,
            ),
          ),
        ),
      ],
    );
  }
}
