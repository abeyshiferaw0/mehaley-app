import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaginationErrorWidget extends StatelessWidget {
  const PaginationErrorWidget({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: AppMargin.margin_16,
            ),
            Text(
              "Check your internet Connection",
              style: TextStyle(
                color: AppColors.lightGrey,
                fontSize: AppFontSizes.font_size_8.sp,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            AppBouncingButton(
              onTap: () {
                onRetry();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_32,
                  vertical: AppPadding.padding_8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(120),
                ),
                child: Text(
                  "Try Again",
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSizes.font_size_10.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppMargin.margin_20,
            ),
          ],
        ),
      ),
    );
  }
}
