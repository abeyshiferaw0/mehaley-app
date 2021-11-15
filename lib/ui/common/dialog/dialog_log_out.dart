import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogLogOut extends StatelessWidget {
  final VoidCallback onLogOut;

  const DialogLogOut({
    Key? key,
    required this.onLogOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            width: ScreenUtil(context: context).getScreenWidth() * 0.8,
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_20,
              vertical: AppPadding.padding_16,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  AppLocale.of().areUSureWantToLogOut,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_8,
                ),
                Text(
                  AppLocale.of().areUSureWantToLogOutMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.txtGrey,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_24,
                ),
                AppBouncingButton(
                  onTap: () {
                    onLogOut();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.padding_20,
                      vertical: AppPadding.padding_4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.orange,
                    ),
                    child: Text(
                      AppLocale.of().logOut.toUpperCase(),
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
                    AppLocale.of().cancel.toUpperCase(),
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
      ),
    );
  }
}
