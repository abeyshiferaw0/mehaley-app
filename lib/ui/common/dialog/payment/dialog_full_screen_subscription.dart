import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/ethio_telecom_related/ethio_telecom_subscription/ethio_telecom_subscription_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/ethio_telecom_related/ethio_telecom_subscription/ethio_telecom_subscription_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/ethio_tele_subscription_offerings.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/ethio_telecom_subscription_util.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogFullScreenSubscription extends StatefulWidget {
  const DialogFullScreenSubscription({Key? key}) : super(key: key);

  @override
  State<DialogFullScreenSubscription> createState() =>
      _DialogFullScreenSubscriptionState();
}

class _DialogFullScreenSubscriptionState
    extends State<DialogFullScreenSubscription> {
  @override
  void initState() {
    ///LOAD ALL ETHIO TELECOM SUBSCRIPTIONS
    BlocProvider.of<EthioTelecomSubscriptionBloc>(context).add(
      LoadEthioTeleSubscriptionOfferingsEvent(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Wrap(
          children: [
            Container(
              width: ScreenUtil(context: context).getScreenWidth() * 0.95,
              height: ScreenUtil(context: context).getScreenHeight() * 0.95,
              decoration: BoxDecoration(
                gradient: AppGradients.getFullScreenSubDialogGradient(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppGradients.getFullScreenSubDialogGradient(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.completelyBlack.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.padding_12,
                      horizontal: AppPadding.padding_18,
                    ),
                    child: BlocConsumer<EthioTelecomSubscriptionBloc,
                        EthioTelecomSubscriptionState>(
                      listener: (context, state) {
                        if (state is EthioTeleSubscriptionLoadingErrorState) {}
                      },
                      builder: (context, state) {
                        if (state is EthioTeleSubscriptionLoadingState) {
                          return buildLoadeingView(context);
                        }

                        if (state is EthioTeleSubscriptionLoadedState) {
                          if (state.ethioTeleSubscriptionOfferings.length > 0) {
                            return buildLoadedView(context,
                                state.ethioTeleSubscriptionOfferings.first);
                          }
                          return buildLoadeingErrorView(context);
                        }

                        if (state is EthioTeleSubscriptionLoadingErrorState) {
                          return buildLoadeingErrorView(context);
                        }

                        return buildLoadeingView(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildLoadedView(BuildContext context,
      EthioTeleSubscriptionOfferings ethioTeleSubscriptionOfferings) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///SKIP BUTTON
          buildCloseButton(context),

          ///HEADER(LOGO TITLE)
          buildHeader(ethioTeleSubscriptionOfferings),

          ///SUBSCRIBE BUTTON
          buildSubButton(ethioTeleSubscriptionOfferings),

          ///BOTTOM INFO
          buildBottomInfo(ethioTeleSubscriptionOfferings),
        ],
      ),
    );
  }

  Column buildBottomInfo(
      EthioTeleSubscriptionOfferings ethioTeleSubscriptionOfferings) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: AppMargin.margin_48,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.padding_6,
          ),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.lightGrey,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_12,
                ),
                child: Text(
                  "OR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.lightGrey,
                  height: 1,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: AppMargin.margin_24,
        ),
        AppBouncingButton(
          onTap: () {
            Navigator.of(context).pop();
            EthioTelecomSubscriptionUtil.onTryClicked(
                context, ethioTeleSubscriptionOfferings);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Send \"${ethioTeleSubscriptionOfferings.shortCodeSubscribeTxt.toUpperCase()}\" To",
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              Text(
                '${ethioTeleSubscriptionOfferings.shortCode}',
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_20.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppMargin.margin_38,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Powered by".toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Container(
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_12,
                    vertical: AppPadding.padding_4,
                  ),
                  child: Image.asset(
                    AppAssets.imageEthioTeleLogo,
                    width: AppIconSizes.icon_size_48 * 1.7,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_24,
        ),
      ],
    );
  }

  AppBouncingButton buildSubButton(
      EthioTeleSubscriptionOfferings ethioTeleSubscriptionOfferings) {
    return AppBouncingButton(
      onTap: () {
        Navigator.of(context).pop();
        EthioTelecomSubscriptionUtil.onTryClicked(
            context, ethioTeleSubscriptionOfferings);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_16,
        ),
        decoration: BoxDecoration(
          color: AppColors.completelyBlack,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().tryForFree.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_4,
            ),
            Icon(
              FlutterRemix.arrow_right_s_line,
              size: AppIconSizes.icon_size_16,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Column buildHeader(
      EthioTeleSubscriptionOfferings ethioTeleSubscriptionOfferings) {
    return Column(
      children: [
        SizedBox(
          height: AppMargin.margin_20,
        ),
        Image.asset(
          AppAssets.icAppWordIconWhite,
          height: AppIconSizes.icon_size_40,
        ),
        SizedBox(
          height: AppMargin.margin_32,
        ),
        Text(
          // AppLocale
          //     .of()
          //     .subscribeDialogTitle,
          ethioTeleSubscriptionOfferings.titleAm,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Text(
          ethioTeleSubscriptionOfferings.descriptionAm,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_8.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_32 * 1.3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().unlimitedStreamingAllMezmurs,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_6,
            ),
            Icon(
              FlutterRemix.checkbox_circle_fill,
              color: AppColors.green,
              size: AppIconSizes.icon_size_16,
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().unlimitedDownloadOffline,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_6,
            ),
            Icon(
              FlutterRemix.checkbox_circle_fill,
              color: AppColors.green,
              size: AppIconSizes.icon_size_16,
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().highQualityAudio,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_6,
            ),
            Icon(
              FlutterRemix.checkbox_circle_fill,
              color: AppColors.green,
              size: AppIconSizes.icon_size_16,
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_32,
        ),
        SizedBox(
          height: AppMargin.margin_20,
        ),
      ],
    );
  }

  Row buildCloseButton(context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        AppBouncingButton(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_8,
              vertical: AppPadding.padding_6,
            ),
            child: Row(
              children: [
                Icon(
                  FlutterRemix.close_line,
                  color: AppColors.lightGrey.withOpacity(0.8),
                  size: AppIconSizes.icon_size_20,
                ),
                SizedBox(
                  width: AppMargin.margin_4,
                ),
                Text(
                  AppLocale.of().close,
                  style: TextStyle(
                    color: ColorMapper.getWhite(),
                    fontSize: AppFontSizes.font_size_16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoadeingView(BuildContext context) {
    return Stack(
      children: [
        ///SKIP BUTTON
        buildCloseButton(context),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: AppIconSizes.icon_size_48,
            height: AppIconSizes.icon_size_48,
            child: CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoadeingErrorView(BuildContext context) {
    return Stack(
      children: [
        ///SKIP BUTTON
        buildCloseButton(context),
        Align(
          alignment: Alignment.center,
          child: AppError(
            onRetry: () {
              ///LOAD ALL ETHIO TELECOM SUBSCRIPTIONS
              BlocProvider.of<EthioTelecomSubscriptionBloc>(context).add(
                LoadEthioTeleSubscriptionOfferingsEvent(),
              );
            },
            bgWidget: Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
