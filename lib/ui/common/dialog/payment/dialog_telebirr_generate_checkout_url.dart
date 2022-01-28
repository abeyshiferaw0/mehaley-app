import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/telebirr/telebirr_generate_checkout_url_bloc/telebirr_generate_checkout_url_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_telebirr_checkout_webview.dart';
import 'package:mehaley/ui/common/widget_error_widget.dart';
import 'package:mehaley/util/screen_util.dart';

import '../../app_loading.dart';

class DialogTelebirrGenerateCheckoutUrl extends StatefulWidget {
  const DialogTelebirrGenerateCheckoutUrl({
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
  State<DialogTelebirrGenerateCheckoutUrl> createState() =>
      _DialogTelebirrGenerateCheckoutUrlState();
}

class _DialogTelebirrGenerateCheckoutUrlState
    extends State<DialogTelebirrGenerateCheckoutUrl> {
  @override
  void initState() {
    ///GENERATE TELEBIRR CHECKOUT URL
    BlocProvider.of<TelebirrGenerateCheckoutUrlBloc>(context).add(
      GenerateCheckoutUrlEvent(
        appPurchasedItemType: widget.appPurchasedItemType,
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///TOP HEADER
                AppTopHeaderWithIcon(),
                Expanded(
                  child: BlocConsumer<TelebirrGenerateCheckoutUrlBloc,
                      TelebirrGenerateCheckoutUrlState>(
                    listener: (context, state) {
                      if (state is TelebirrCheckoutUrlGeneratedState) {
                        Navigator.pop(context);

                        ///SHOW TELEBIRR CHECKOUT WEB VIEW DIALOG
                        showDialog(
                          context: context,
                          builder: (context) {
                            ///SHOW GENERATE TELEBIRR CHECKOUT URL DIALOG
                            return DialogTelebirrCheckoutWebView(
                              itemId: widget.itemId,
                              appPurchasedItemType: widget.appPurchasedItemType,
                              transactionNumber: state.transactionNumber,
                              checkOutUrl: state.checkoutUrl,
                              isFromSelfPage: widget.isFromSelfPage,
                              appPurchasedSources: widget.appPurchasedSources,
                            );
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is TelebirrCheckoutUrlGeneratingState) {
                        return buildLoading();
                      }
                      if (state is TelebirrCheckoutUrlGeneratingErrorState) {
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
          ///GENERATE TELEBIRR CHECKOUT URL
          BlocProvider.of<TelebirrGenerateCheckoutUrlBloc>(context).add(
            GenerateCheckoutUrlEvent(
              appPurchasedItemType: widget.appPurchasedItemType,
              itemId: widget.itemId,
            ),
          );
        },
      ),
    );
  }
}
