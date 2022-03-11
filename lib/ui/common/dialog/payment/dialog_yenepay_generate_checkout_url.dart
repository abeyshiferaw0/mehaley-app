import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/yenepay/yenepay_generate_checkout_url_bloc/yenepay_generate_checkout_url_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/yenepay/yenepay_payment_launcher_listener_bloc/yenepay_payment_launcher_listener_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/widget_error_widget.dart';
import 'package:mehaley/util/screen_util.dart';

import '../../app_loading.dart';

class DialogYenepayGenerateCheckoutUrl extends StatefulWidget {
  const DialogYenepayGenerateCheckoutUrl({
    Key? key,
    required this.itemId,
    required this.appPurchasedItemType,
    required this.appPurchasedSources,
    required this.isFromSelfPage,
  }) : super(key: key);

  final int itemId;

  final AppPurchasedItemType appPurchasedItemType;

  final AppPurchasedSources appPurchasedSources;
  final bool isFromSelfPage;

  @override
  State<DialogYenepayGenerateCheckoutUrl> createState() =>
      _DialogYenepayGenerateCheckoutUrlState();
}

class _DialogYenepayGenerateCheckoutUrlState
    extends State<DialogYenepayGenerateCheckoutUrl> {
  @override
  void initState() {
    ///GENERATE YENEPAY CHECKOUT URL
    BlocProvider.of<YenepayGenerateCheckoutUrlBloc>(context).add(
      GenerateCheckoutUrlEvent(
        appPurchasedItemType: widget.appPurchasedItemType,
        appPurchasedSources: widget.appPurchasedSources,
        isFromSelfPage: widget.isFromSelfPage,
        itemId: widget.itemId,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            width: ScreenUtil(context: context).getScreenWidth() * 0.9,
            height: ScreenUtil(context: context).getScreenHeight() * 0.7,
            decoration: BoxDecoration(
              color: ColorMapper.getWhite(),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///TOP HEADER
                AppTopHeaderWithIcon(),
                Expanded(
                  child: BlocConsumer<YenepayGenerateCheckoutUrlBloc,
                      YenepayGenerateCheckoutUrlState>(
                    listener: (context, state) {
                      if (state is YenepayCheckoutUrlGeneratedState) {
                        Navigator.pop(context);

                        ///SHOW YENEPAY CHECKOUT WEB VIEW DIALOG
                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     ///SHOW GENERATE YENEPAY CHECKOUT URL DIALOG
                        //     return DialogYenepayCheckoutWebView(
                        //       itemId: widget.itemId,
                        //       appPurchasedItemType: widget.appPurchasedItemType,
                        //       checkOutUrl: state.checkoutUrl,
                        //       isFromSelfPage: widget.isFromSelfPage,
                        //       appPurchasedSources: widget.appPurchasedSources,
                        //     );
                        //   },
                        // );

                        ///START YENEPAY PAYMENT
                        BlocProvider.of<YenepayPaymentLauncherListenerBloc>(
                                context)
                            .add(
                          LaunchYenepayPaymentPageEvent(
                            launchUrl: state.checkoutUrl,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is YenepayCheckoutUrlGeneratingState) {
                        return buildLoading();
                      }
                      if (state is YenepayCheckoutUrlGeneratingErrorState) {
                        return buildError();
                      }

                      return buildLoading();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_32),
      child: AppLoading(
        size: AppValues.loadingWidgetSize * 0.8,
      ),
    );
  }

  Widget buildError() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_32),
      child: WidgetErrorWidget(
        title: AppLocale.of().noInternetMsg,
        subTitle: AppLocale.of().checkYourInternetConnection,
        onRetry: () {
          ///GENERATE YENEPAY CHECKOUT URL
          BlocProvider.of<YenepayGenerateCheckoutUrlBloc>(context).add(
            GenerateCheckoutUrlEvent(
              itemId: widget.itemId,
              appPurchasedItemType: widget.appPurchasedItemType,
              appPurchasedSources: widget.appPurchasedSources,
              isFromSelfPage: widget.isFromSelfPage,
            ),
          );
        },
      ),
    );
  }
}
