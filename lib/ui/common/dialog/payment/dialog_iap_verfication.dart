import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_purchase_action_bloc/iap_purchase_action_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_purchase_verification_bloc/iap_purchase_verification_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/iap_verfication_error_widget.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogIapVerification extends StatefulWidget {
  const DialogIapVerification({
    Key? key,
    required this.itemId,
    required this.appPurchasedItemType,
    required this.purchasedItem,
    required this.isFromSelfPage,
    required this.purchaseToken,
    required this.appPurchasedSources,
  }) : super(key: key);

  final int itemId;
  final AppPurchasedItemType appPurchasedItemType;
  final bool isFromSelfPage;
  final PurchasedItem purchasedItem;
  final String purchaseToken;
  final AppPurchasedSources appPurchasedSources;

  @override
  State<DialogIapVerification> createState() => _DialogIapVerificationState();
}

class _DialogIapVerificationState extends State<DialogIapVerification>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    ///VERIFY AND STARE PURCHASE
    BlocProvider.of<IapPurchaseVerificationBloc>(context).add(
      IapPurchaseVerifyEvent(
        itemId: widget.itemId,
        appPurchasedItemType: widget.appPurchasedItemType,
        purchasedItem: widget.purchasedItem,
        purchaseToken: widget.purchaseToken,
      ),
    );
    _controller = AnimationController(
      vsync: this,
    );
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);

          ///IAP PURCHASE SUCCESS ACTIONS MAPPING
          if (widget.appPurchasedItemType ==
              AppPurchasedItemType.SONG_PAYMENT) {
            BlocProvider.of<IapPurchaseActionBloc>(context).add(
              IapSongPurchaseActionEvent(
                itemId: widget.itemId,
                appPurchasedSources: widget.appPurchasedSources,
              ),
            );
          }
          if (widget.appPurchasedItemType ==
              AppPurchasedItemType.ALBUM_PAYMENT) {
            BlocProvider.of<IapPurchaseActionBloc>(context).add(
              IapAlbumPurchaseActionEvent(
                itemId: widget.itemId,
                isFromSelfPage: widget.isFromSelfPage,
                appPurchasedSources: widget.appPurchasedSources,
              ),
            );
          }
          if (widget.appPurchasedItemType ==
              AppPurchasedItemType.PLAYLIST_PAYMENT) {
            BlocProvider.of<IapPurchaseActionBloc>(context).add(
              IapPlaylistPurchaseActionEvent(
                itemId: widget.itemId,
                isFromSelfPage: widget.isFromSelfPage,
                appPurchasedSources: widget.appPurchasedSources,
              ),
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppCard(
        radius: 6,
        child: Material(
          child: Wrap(
            children: [
              Container(
                width: ScreenUtil(context: context).getScreenWidth() * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: BlocConsumer<IapPurchaseVerificationBloc,
                    IapPurchaseVerificationState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is IapPurchaseVerificationLoadedState) {
                      if (state.isValid) {
                        ///state.isAlreadyPurchased
                        return buildLoadedValid();
                      } else {
                        return buildLoadedNotValid();
                      }
                    }
                    if (state is IapPurchaseVerificationLoadingState) {
                      return buildLoading();
                    }
                    if (state is IapPurchaseVerificationLoadingErrorState) {
                      return buildError();
                    }
                    return buildLoading();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoadedValid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///TOP HEADER
        AppTopHeaderWithIcon(),
        Container(
          padding: EdgeInsets.all(AppPadding.padding_16),
          child: Column(
            children: [
              Lottie.asset(
                AppAssets.successLottieTwo,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
                repeat: false,
                width: AppIconSizes.icon_size_64 * 2,
                height: AppIconSizes.icon_size_64 * 2,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              Text(
                "Purchase Completed".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLoadedNotValid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///TOP HEADER
        AppTopHeaderWithIcon(),
        Container(
          padding: EdgeInsets.all(AppPadding.padding_16),
          child: Column(
            children: [
              Lottie.asset(
                AppAssets.cancelledLottie,
                width: AppIconSizes.icon_size_32,
                height: AppIconSizes.icon_size_32,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              Text(
                "Your Purchase Could Not Be Verified".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_8,
              ),
              Text(
                "There was a problem verifying your purchase\nplease try again!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.txtGrey,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_20,
              ),
              AppBouncingButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Close".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///TOP HEADER
        AppTopHeaderWithIcon(disableCloseButton: true),
        Container(
          padding: EdgeInsets.all(AppPadding.padding_16),
          child: Column(
            children: [
              AppLoading(
                size: AppValues.loadingWidgetSize * 0.6,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              Text(
                "Completing your purchase\nplease wait...".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///TOP HEADER
        AppTopHeaderWithIcon(),
        Container(
          padding: EdgeInsets.all(AppPadding.padding_16),
          child: Column(
            children: [
              IapVerificationErrorWidget(
                onRetry: () {
                  ///VERIFY AND STARE PURCHASE
                  BlocProvider.of<IapPurchaseVerificationBloc>(context).add(
                    IapPurchaseVerifyEvent(
                      itemId: widget.itemId,
                      appPurchasedItemType: widget.appPurchasedItemType,
                      purchasedItem: widget.purchasedItem,
                      purchaseToken: widget.purchaseToken,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
