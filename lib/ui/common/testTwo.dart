import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class TestTwoWidget extends StatefulWidget {
  const TestTwoWidget({Key? key}) : super(key: key);

  @override
  _TestTwoWidgetState createState() => _TestTwoWidgetState();
}

class _TestTwoWidgetState extends State<TestTwoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            "Update required to continue using mehaleye".toUpperCase(),
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
            "Dear user update message Dear user update message Dear user update message Dear user update message",
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
            onTap: () {},
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
                "Update App".toUpperCase(),
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
                "Current Version\n1.0.2".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSizes.font_size_6.sp,
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
                "Newer Version\n1.0.5".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSizes.font_size_6.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
