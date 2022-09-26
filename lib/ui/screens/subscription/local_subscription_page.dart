import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/ethio_telecom_related/ethio_telecom_subscription/ethio_telecom_subscription_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_page_bloc/iap_subscription_page_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/ethio_tele_subscription_offerings.dart';
import 'package:mehaley/data/models/subscription_offerings.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/screens/subscription/widgets/ethio_telecom_offering_card.dart';
import 'package:mehaley/ui/screens/subscription/widgets/offering_card.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalSubscriptionPage extends StatefulWidget {
  const LocalSubscriptionPage({Key? key}) : super(key: key);

  @override
  State<LocalSubscriptionPage> createState() => _LocalSubscriptionPageState();
}

class _LocalSubscriptionPageState extends State<LocalSubscriptionPage> {
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
    return BlocBuilder<EthioTelecomSubscriptionBloc,
        EthioTelecomSubscriptionState>(
      builder: (context, state) {
        if (state is EthioTeleSubscriptionLoadingState) {
          return buildPageLoading();
        }

        if (state is EthioTeleSubscriptionLoadedState) {
          return buildPageLoaded(
            state.ethioTeleSubscriptionOfferings,
          );
        }
        if (state is EthioTeleSubscriptionLoadingErrorState) {
          return buildPageError(
            Key(
              state.dateTime.toString(),
            ),
          );
        }
        return buildPageLoading();
      },
    );
  }

  Widget buildPageLoaded(
      List<EthioTeleSubscriptionOfferings> ethioTeleSubscriptionOfferings) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          ///PLANS LIST
          buildSliverList(ethioTeleSubscriptionOfferings),

          buildSubInfo(ethioTeleSubscriptionOfferings),

          ///PLANS INFO
          buildPlansInfo(),
        ],
      ),
    );
  }

  buildSubInfo(
      List<EthioTeleSubscriptionOfferings> ethioTeleSubscriptionOfferings) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.padding_24,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.txtGrey,
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
                      fontSize: AppFontSizes.font_size_14.sp,
                      color: AppColors.txtGrey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.txtGrey,
                    height: 1,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: AppMargin.margin_24,
          ),
          Text(
            "SUBSCRIBE BY SENDING \"${ethioTeleSubscriptionOfferings.first.shortCodeSubscribeTxt}\" TO",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_14.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_24,
          ),
          Text(
            '${ethioTeleSubscriptionOfferings.first.shortCode}',
            style: TextStyle(
              fontSize: AppFontSizes.font_size_24.sp,
              color: AppColors.darkOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Powered by".toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  color: AppColors.txtGrey,
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
                      width: AppIconSizes.icon_size_48 * 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppMargin.margin_24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.padding_24,
            ),
            child: Divider(
              color: AppColors.txtGrey,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildPlansInfo() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().unlimitedStreamingAllMezmurs,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
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
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
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
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
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
        ],
      ),
    );
  }

  SliverToBoxAdapter buildSliverList(
      List<EthioTeleSubscriptionOfferings> ethioTeleSubscriptionOfferings) {
    return SliverToBoxAdapter(
      child: ListView.builder(
        itemCount: ethioTeleSubscriptionOfferings.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return EthioTelecomOfferingCard(
            ethioTeleSubscriptionOfferings:
                ethioTeleSubscriptionOfferings.elementAt(
              index,
            ),
          );
        },
      ),
    );
  }

  Widget buildPageLoading() {
    return AppLoading(
      size: AppValues.loadingWidgetSize,
    );
  }

  Widget buildPageError(key) {
    return AppError(
      key: key,
      bgWidget: AppLoading(
        size: AppValues.loadingWidgetSize,
      ),
      onRetry: () {
        ///LOAD ALL ETHIO TELECOM SUBSCRIPTIONS
        BlocProvider.of<EthioTelecomSubscriptionBloc>(context).add(
          LoadEthioTeleSubscriptionOfferingsEvent(),
        );
      },
    );
  }
}
