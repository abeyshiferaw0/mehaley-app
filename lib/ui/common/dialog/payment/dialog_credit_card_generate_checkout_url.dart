import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/credit_card/credit_card_generate_checkout_url_bloc/credit_card_generate_checkout_url_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_credit_card_checkout_webview.dart';
import 'package:mehaley/ui/common/widget_error_widget.dart';
import 'package:mehaley/util/screen_util.dart';

import '../../app_loading.dart';

class DialogCreditCardGenerateCheckoutUrl extends StatefulWidget {
  const DialogCreditCardGenerateCheckoutUrl({
    Key? key,
    required this.itemId,
    required this.purchasedItemType,
    required this.appPurchasedSources,
    required this.isFromSelfPage,
  }) : super(key: key);

  final int itemId;
  final PurchasedItemType purchasedItemType;
  final AppPurchasedSources appPurchasedSources;
  final bool isFromSelfPage;

  @override
  State<DialogCreditCardGenerateCheckoutUrl> createState() =>
      _DialogCreditCardGenerateCheckoutUrlState();
}

class _DialogCreditCardGenerateCheckoutUrlState
    extends State<DialogCreditCardGenerateCheckoutUrl> {
  @override
  void initState() {
    ///GENERATE CREDIT CARD CHECKOUT URL
    BlocProvider.of<CreditCardGenerateCheckoutUrlBloc>(context).add(
      GenerateCheckoutUrlEvent(
        purchasedItemType: widget.purchasedItemType,
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
                  child: BlocConsumer<CreditCardGenerateCheckoutUrlBloc,
                      CreditCardGenerateCheckoutUrlState>(
                    listener: (context, state) {
                      if (state is CreditCardCheckIsFreeState) {
                        ///POP FIRST
                        Navigator.pop(context);

                        ///SHOW IS FREE MSG
                        ScaffoldMessenger.of(context).showSnackBar(
                          buildAppSnackBar(
                            bgColor: AppColors.blue,
                            txtColor: ColorMapper.getWhite(),
                            msg: AppLocale.of().itemIsFreeMsg(
                              purchasedItemType: widget.purchasedItemType,
                            ),
                            isFloating: true,
                          ),
                        );
                      }

                      if (state is CreditCardCheckIsAlreadyBoughtState) {
                        ///POP FIRST
                        Navigator.pop(context);

                        ///SHOW IS FREE MSG
                        ScaffoldMessenger.of(context).showSnackBar(
                          buildAppSnackBar(
                            bgColor: AppColors.blue,
                            txtColor: ColorMapper.getWhite(),
                            msg: AppLocale.of().alreadyPurchasedTryRefreshMsg(
                                purchasedItemType: widget.purchasedItemType),
                            isFloating: true,
                          ),
                        );
                      }

                      if (state is CreditCardCheckoutUrlGeneratedState) {
                        ///POP FIRST
                        Navigator.pop(context);

                        ///SHOW CYBERSOURCE PAYMENT PAGE
                        showDialog(
                          context: context,
                          builder: (context) {
                            ///SHOW GENERATE CREDIT CARD CHECKOUT URL DIALOG
                            return DialogCreditCardCheckoutWebView(
                              itemId: widget.itemId,
                              purchasedItemType: widget.purchasedItemType,
                              checkOutUrl: state.checkOutUrl,
                              creditCardResult: state.creditCardResult,
                              isFromSelfPage: widget.isFromSelfPage,
                              appPurchasedSources: widget.appPurchasedSources,
                            );
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CreditCardCheckoutUrlGeneratingState) {
                        return buildLoading();
                      }
                      if (state is CreditCardCheckoutUrlGeneratingErrorState) {
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
          ///GENERATE CREDIT CARD CHECKOUT URL
          BlocProvider.of<CreditCardGenerateCheckoutUrlBloc>(context).add(
            GenerateCheckoutUrlEvent(
              itemId: widget.itemId,
              purchasedItemType: widget.purchasedItemType,
            ),
          );
        },
      ),
    );
  }
}
