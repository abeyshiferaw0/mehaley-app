import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';

class PhoneAuthLargeButton extends StatelessWidget {
  const PhoneAuthLargeButton({
    Key? key,
    required this.onTap,
    required this.disableBouncing,
    required this.isLoading,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool disableBouncing;
  final bool isLoading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      disableBouncing: disableBouncing,
      onTap: onTap,
      shrinkRatio: 6,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_16,
          vertical: AppPadding.padding_14,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkOrange,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading
                  ? Container(
                      width: AppIconSizes.icon_size_16,
                      height: AppIconSizes.icon_size_16,
                      margin: EdgeInsets.only(
                        right: AppMargin.margin_8,
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: AppColors.white,
                      ),
                    )
                  : SizedBox(),
              Text(
                text,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_14,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: AppMargin.margin_8,
              ),
              isLoading != true
                  ? Icon(
                      FlutterRemix.arrow_right_s_line,
                      color: AppColors.white,
                      size: AppIconSizes.icon_size_12,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
