import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogUlLikeUnFollow extends StatelessWidget {
  final VoidCallback onUnLikeUnFollow;
  final String titleText;
  final String mainButtonText;
  final String cancelButtonText;

  const DialogUlLikeUnFollow({
    Key? key,
    required this.onUnLikeUnFollow,
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
            color: ColorMapper.getWhite(),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Text(
                titleText,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorMapper.getBlack(),
                ),
              ),
              SizedBox(
                height: AppMargin.margin_32,
              ),
              AppBouncingButton(
                onTap: () {
                  onUnLikeUnFollow();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_16,
                    vertical: AppPadding.padding_4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: ColorMapper.getOrange(),
                  ),
                  child: Text(
                    mainButtonText,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorMapper.getWhite(),
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
                    color: ColorMapper.getBlack(),
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
