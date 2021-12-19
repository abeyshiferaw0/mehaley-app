import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({
    Key? key,
    required this.copyText,
    required this.title,
  }) : super(key: key);

  final String copyText;
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        ///COPY TEXT TO CLIP BOARD
        Clipboard.setData(
          ClipboardData(text: copyText),
        ).then(
          (value) {
            // ///SHOW COPED SNACK
            // ScaffoldMessenger.of(context).showSnackBar(
            //   buildAppSnackBar(
            //     bgColor: AppColors.black.withOpacity(0.9),
            //     isFloating: true,
            //     msg: AppLocale.of().copiedToClipboard,
            //     txtColor: AppColors.white,
            //   ),
            // );
            showSimpleNotification(
              Container(
                padding: EdgeInsets.all(AppPadding.padding_8),
                color: AppColors.white,
                child: Center(
                  child: Text(
                    AppLocale.of().copiedToClipboard,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: AppFontSizes.font_size_10.sp,
                    ),
                  ),
                ),
              ),
              contentPadding: EdgeInsets.zero,
              background: AppColors.white,
              duration: Duration(milliseconds: 1200),
            );
          },
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FlutterRemix.file_copy_line,
            size: AppIconSizes.icon_size_12,
            color: AppColors.blue,
          ),
          SizedBox(
            width: AppMargin.margin_2,
          ),
          Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
