import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/copy_button.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_pay_with_carousel.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogBillInfo extends StatefulWidget {
  @override
  State<DialogBillInfo> createState() => _DialogBillInfoState();
}

class _DialogBillInfoState extends State<DialogBillInfo> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Material(
            child: Container(
              width: ScreenUtil(context: context).getScreenWidth() * 0.9,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDialogHeader(),
                  SizedBox(
                    height: AppMargin.margin_24,
                  ),
                  buildBillInfo(),
                  SizedBox(
                    height: AppMargin.margin_32,
                  ),
                  WalletPayWithCarousel(),
                  // SizedBox(
                  //   height: AppMargin.margin_48,
                  // ),
                  // buildDoneButton(context),
                  // SizedBox(
                  //   height: AppMargin.margin_24,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBouncingButton buildDoneButton(BuildContext context) {
    return AppBouncingButton(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_12,
          vertical: AppPadding.padding_12,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppMargin.margin_16,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkOrange,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().done.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDialogHeader() {
    return Container(
      padding: EdgeInsets.all(
        AppPadding.padding_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  AppLocale.of().payBill,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              AppBouncingButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.padding_8),
                  child: Icon(
                    FlutterRemix.close_line,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          Text(
            AppLocale.of().billInfoMsg,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
        ],
      ),
    );
  }

  Container buildBillInfo() {
    return Container(
      padding: EdgeInsets.all(
        AppPadding.padding_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.of().amount,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '34',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontSize: AppFontSizes.font_size_18.sp,
              ),
              children: [
                TextSpan(
                  text: ' ${AppLocale.of().birr}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.txtGrey,
                    fontSize: AppFontSizes.font_size_10.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Text(
            AppLocale.of().billCode,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '345 987 908',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: AppFontSizes.font_size_18.sp,
                ),
              ),
              SizedBox(
                width: AppMargin.margin_8,
              ),
              CopyButton(
                copyText: '345 987 908',
                title: AppLocale.of().copyCode,
              )
            ],
          ),
        ],
      ),
    );
  }
}
