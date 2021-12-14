import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class ForceUpdateWidget extends StatefulWidget {
  const ForceUpdateWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ForceUpdateWidgetState createState() => _ForceUpdateWidgetState();
}

class _ForceUpdateWidgetState extends State<ForceUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final String newVersion = args.args['newVersion'];
    final String currentVersion = args.args['currentVersion'];
    return Scaffold(
      body: Container(
        height: ScreenUtil(context: context).getScreenHeight(),
        width: ScreenUtil(context: context).getScreenWidth(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.orange, AppColors.orange2],
          ),
        ),
        padding: EdgeInsets.all(AppPadding.padding_32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              AppAssets.icAppFullIconWhite,
              width: ScreenUtil(context: context).getScreenWidth() * 0.6,
            ),
            SizedBox(
              height: ScreenUtil(context: context).getScreenHeight() * 0.05,
            ),
            Text(
              AppLocale.of().updateRequired.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppFontSizes.font_size_12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: ScreenUtil(context: context).getScreenHeight() * 0.2,
            ),
            Text(
              AppLocale.of().updateRequiredMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: ScreenUtil(context: context).getScreenHeight() * 0.05,
            ),
            AppBouncingButton(
              onTap: () {
                ///OPEN PLAY STORE APP STORE
                InAppReview.instance
                    .openStoreListing(appStoreId: AppValues.appStoreId);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: AppColors.completelyBlack.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 12,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_32,
                  vertical: AppPadding.padding_12,
                ),
                child: Text(
                  AppLocale.of().updateApp.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil(context: context).getScreenHeight() * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppLocale.of().currentVersion}\n$currentVersion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
                  child: Icon(
                    FlutterRemix.arrow_right_s_line,
                    color: AppColors.lightGrey,
                    size: AppIconSizes.icon_size_20,
                  ),
                ),
                Text(
                  '${AppLocale.of().newerVersion}\n$newVersion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
