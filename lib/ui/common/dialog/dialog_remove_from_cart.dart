import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DialogRemoveFromCart extends StatelessWidget {
  final VoidCallback onRemove;
  final String titleText;
  final String mainButtonText;
  final String cancelButtonText;

  const DialogRemoveFromCart({
    Key? key,
    required this.onRemove,
    required this.titleText,
    required this.mainButtonText,
    required this.cancelButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: ScreenUtil(context: context).getScreenWidth() * 0.8,
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_20,
            vertical: AppPadding.padding_32,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Text(
                titleText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_32,
              ),
              AppBouncingButton(
                onTap: () {
                  onRemove();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_20,
                    vertical: AppPadding.padding_4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.green,
                  ),
                  child: Text(
                    mainButtonText,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppMargin.margin_20,
              ),
              AppBouncingButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  cancelButtonText,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
