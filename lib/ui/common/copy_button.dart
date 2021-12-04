import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

import 'app_snack_bar.dart';

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
            ///SHOW COPED SNACK
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.black.withOpacity(0.9),
                isFloating: false,
                msg: AppLocale.of().copiedToClipboard,
                txtColor: AppColors.white,
              ),
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
