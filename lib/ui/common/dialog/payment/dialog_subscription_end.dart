import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogSubscriptionEnd extends StatefulWidget {
  const DialogSubscriptionEnd({
    Key? key,
    required this.onGoToSubscriptionPage,
  }) : super(key: key);

  final VoidCallback onGoToSubscriptionPage;

  @override
  State<DialogSubscriptionEnd> createState() => _DialogSubscriptionEndState();
}

class _DialogSubscriptionEndState extends State<DialogSubscriptionEnd> {
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
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///TOP HEADER
                    AppTopHeaderWithIcon(),
                    Container(
                      height: AppIconSizes.icon_size_64 * 2,
                      child: Lottie.asset(
                        AppAssets.subscriptionEndLottie,
                      ),
                    ),
                    Text(
                      "Sad to see you go",
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
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
                        "Your subscription could not be renewed, due to active cancellation or payment issues.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (AppFontSizes.font_size_10 - 1).sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
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
                          ///POP DIALOG AND GOT TO SUBSCRIBE PAGE
                          Navigator.pop(context);
                          widget.onGoToSubscriptionPage();
                        },
                        child: AppCard(
                          radius: 100.0,
                          child: Container(
                            color: AppColors.darkOrange,
                            padding: EdgeInsets.all(
                              AppPadding.padding_12,
                            ),
                            child: Center(
                              child: Text(
                                "Resubscribe",
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_10.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_8,
                    ),
                    AppBouncingButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppPadding.padding_8,
                        ),
                        child: Text(
                          "No, thanks",
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_10.sp,
                            color: AppColors.txtGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: AppMargin.margin_8,
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
