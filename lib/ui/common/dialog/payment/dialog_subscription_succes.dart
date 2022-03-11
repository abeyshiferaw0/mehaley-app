import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogSubscriptionSuccess extends StatefulWidget {
  const DialogSubscriptionSuccess({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogSubscriptionSuccess> createState() =>
      _DialogSubscriptionSuccessState();
}

class _DialogSubscriptionSuccessState extends State<DialogSubscriptionSuccess> {
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
                color: ColorMapper.getWhite(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///TOP HEADER
                    AppTopHeaderWithIcon(),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(
                              AppPadding.padding_32,
                            ),
                            height: AppIconSizes.icon_size_64 * 2,
                            child: Image.asset(
                              AppAssets.icAppIconOnly,
                              width: AppIconSizes.icon_size_64,
                              height: AppIconSizes.icon_size_64,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: AppIconSizes.icon_size_64 * 2,
                            child: Lottie.asset(
                              AppAssets.subscriptionSuccess,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppLocale.of().thankYouForSubscribing,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_12.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorMapper.getBlack(),
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.padding_12,
                        vertical: AppPadding.padding_8,
                      ),
                      child: Text(
                        AppLocale.of().subscribedMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (AppFontSizes.font_size_10 - 1).sp,
                          fontWeight: FontWeight.w400,
                          color: ColorMapper.getBlack(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.padding_16,
                      ),
                      child: AppBouncingButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: AppCard(
                          radius: 100.0,
                          child: Container(
                            color: ColorMapper.getDarkOrange(),
                            padding: EdgeInsets.all(
                              AppPadding.padding_12,
                            ),
                            child: Center(
                              child: Text(
                                AppLocale.of().continueStr,
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_10.sp,
                                  color: ColorMapper.getWhite(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_16,
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
}
