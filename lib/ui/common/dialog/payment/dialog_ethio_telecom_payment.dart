import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/ethio_telecom_related/ethio_telecom/ethio_telecom_payment_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_purchase_action_bloc/iap_purchase_action_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/widget_error_widget.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../../app_loading.dart';

class DialogEthioTelecomPayment extends StatefulWidget {
  const DialogEthioTelecomPayment({
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
  State<DialogEthioTelecomPayment> createState() =>
      _DialogEthioTelecomPaymentState();
}

class _DialogEthioTelecomPaymentState extends State<DialogEthioTelecomPayment> {
  @override
  void initState() {
    ///START PURCHASING ITEM WITH ETHIO TELECOM
    BlocProvider.of<EthioTelecomPaymentBloc>(context).add(
      StartEthioTelecomPaymentEvent(
        itemId: widget.itemId,
        purchasedItemType: widget.purchasedItemType,
        isFromItemSelfPage: widget.isFromSelfPage,
        appPurchasedSources: widget.appPurchasedSources,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppCard(
        radius: 6,
        child: Wrap(
          children: [
            Container(
              width: ScreenUtil(context: context).getScreenWidth() * 0.9,
              height: ScreenUtil(context: context).getScreenHeight() * 0.6,
              color: ColorMapper.getWhite(),
              child: Column(
                children: [
                  AppTopHeaderWithIcon(),
                  Expanded(
                    child: BlocConsumer<EthioTelecomPaymentBloc,
                        EthioTelecomPaymentState>(
                      listener: (context, state) {
                        if (state is EthioTelecomPurchasedSuccessState) {
                          ///PAYMENT SUCCESS
                          onSuccess();
                        }

                        if (state is EthioTelecomPurchasedIsFreeState) {
                          ///POP FIRST
                          Navigator.pop(context);

                          ///SHOW IS FREE MSG
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildAppSnackBar(
                              bgColor: AppColors.blue,
                              txtColor: ColorMapper.getWhite(),
                              msg: AppLocale.of().itemIsFreeMsg(
                                  purchasedItemType: widget.purchasedItemType),
                              isFloating: true,
                            ),
                          );
                        }
                        if (state is EthioTelecomIsAlreadyBoughtState) {
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
                      },
                      builder: (context, state) {
                        if (state is EthioTelecomPurchasingState) {
                          ///BUILD LOADING
                          return buildLoading();
                        }

                        if (state
                            is EthioTelecomPurchaseBalanceNotEnoughState) {
                          ///BALANCE NOT ENOUGH MSG
                          return buildBalanceNotEnoughMsg();
                        }

                        if (state is EthioTelecomPurchasingFailedState) {
                          ///BUILD ERROR
                          return buildError();
                        }

                        if (state is EthioTelecomPurchaseNotSuccessState) {
                          ///BUILD ERROR FROM TELE OR PAYMENT SERVER SIDE
                          return buildPaymentNotSuccessError();
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
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      color: ColorMapper.getWhite(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppLoading(
            size: AppValues.loadingWidgetSize * 0.8,
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Text(
            AppLocale.of().completeingYourPurchase,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBalanceNotEnoughMsg() {
    return Container(
      color: ColorMapper.getWhite(),
      padding: EdgeInsets.all(AppPadding.padding_16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocale.of().balanceNotEnoughForPurchase(
                purchasedItemType: widget.purchasedItemType),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600),
          ),
          Container(
            height: AppIconSizes.icon_size_72 * 3,
            child: Lottie.asset(
              AppAssets.handPhoneLottie,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_2,
          ),
          Text(
            AppLocale.of().balanceNotEnoughMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              color: AppColors.txtGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_32,
          ),
          AppBouncingButton(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_32,
                vertical: AppPadding.padding_16,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_32,
              ),
              decoration: BoxDecoration(
                color: ColorMapper.getDarkOrange(),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  AppLocale.of().close.toUpperCase(),
                  style: TextStyle(
                    color: ColorMapper.getWhite(),
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSizes.font_size_10.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildError() {
    return Container(
      color: ColorMapper.getWhite(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32,
          ),
          child: WidgetErrorWidget(
            onRetry: () {
              BlocProvider.of<EthioTelecomPaymentBloc>(context).add(
                StartEthioTelecomPaymentEvent(
                  itemId: widget.itemId,
                  purchasedItemType: widget.purchasedItemType,
                  isFromItemSelfPage: widget.isFromSelfPage,
                  appPurchasedSources: widget.appPurchasedSources,
                ),
              );
            },
            title: AppLocale.of().noInternetMsgDetail,
            subTitle: '',
          ),
        ),
      ),
    );
  }

  Widget buildPaymentNotSuccessError() {
    return Container(
      color: ColorMapper.getWhite(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32,
          ),
          child: WidgetErrorWidget(
            onRetry: () {
              BlocProvider.of<EthioTelecomPaymentBloc>(context).add(
                StartEthioTelecomPaymentEvent(
                  itemId: widget.itemId,
                  purchasedItemType: widget.purchasedItemType,
                  isFromItemSelfPage: widget.isFromSelfPage,
                  appPurchasedSources: widget.appPurchasedSources,
                ),
              );
            },
            title: 'Something went wrong!!',
            subTitle: 'please try again after a while',
          ),
        ),
      ),
    );
  }

  void onSuccess() {
    Navigator.pop(context);

    ///TELE CARD PURCHASE SUCCESS ACTIONS MAPPING
    if (widget.purchasedItemType == PurchasedItemType.SONG_PAYMENT) {
      BlocProvider.of<IapPurchaseActionBloc>(context).add(
        IapSongPurchaseActionEvent(
          itemId: widget.itemId,
          appPurchasedSources: widget.appPurchasedSources,
        ),
      );
    }
    if (widget.purchasedItemType == PurchasedItemType.ALBUM_PAYMENT) {
      BlocProvider.of<IapPurchaseActionBloc>(context).add(
        IapAlbumPurchaseActionEvent(
          itemId: widget.itemId,
          isFromSelfPage: widget.isFromSelfPage,
          appPurchasedSources: widget.appPurchasedSources,
        ),
      );
    }
    if (widget.purchasedItemType == PurchasedItemType.PLAYLIST_PAYMENT) {
      BlocProvider.of<IapPurchaseActionBloc>(context).add(
        IapPlaylistPurchaseActionEvent(
          itemId: widget.itemId,
          isFromSelfPage: widget.isFromSelfPage,
          appPurchasedSources: widget.appPurchasedSources,
        ),
      );
    }
  }
}
