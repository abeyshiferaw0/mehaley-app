import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../app_top_header_with_icon.dart';

class DialogSubscribeNotAvailable extends StatelessWidget {
  const DialogSubscribeNotAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppCard(
        radius: 6.0,
        child: Material(
          child: Wrap(
            children: [
              Container(
                width: ScreenUtil(context: context).getScreenWidth() * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    AppTopHeaderWithIcon(),
                    Container(
                      padding: EdgeInsets.all(AppPadding.padding_16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: AppMargin.margin_16,
                          ),
                          buildDialogTitle(context),
                          SizedBox(
                            height: AppMargin.margin_8,
                          ),
                          buildDialogSubTitle(context),
                          SizedBox(
                            height: AppMargin.margin_32,
                          ),
                          buildSubscribeButton(context),
                          SizedBox(
                            height: AppMargin.margin_16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildDialogTitle(context) {
    return Text(
      "Subscription currently not available",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
    );
  }

  Padding buildDialogSubTitle(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      child: Text(
        "Subscription is currently not available in your country, we will notify you when available.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (AppFontSizes.font_size_10 - 1).sp,
          fontWeight: FontWeight.w300,
          color: AppColors.black,
        ),
      ),
    );
  }

  AppBouncingButton buildSubscribeButton(context) {
    return AppBouncingButton(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_32,
          vertical: AppPadding.padding_12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          gradient: AppGradients.getSubscribeButtonGradient(),
        ),
        child: Center(
          child: Text(
            "Close".toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
