import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/complete_purchase_dialog_bloc/complete_purchase_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/preferred_payment_method_bloc/preferred_payment_method_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/dialog/widgets/payment_item.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogCompletePurchase extends StatefulWidget {
  const DialogCompletePurchase(
      {Key? key,
      required this.onYenepaySelected,
      required this.onCreditCardSelected,
      required this.onEthioTelecomSelected,
      required this.onTelebirrSelected,
      required this.onInAppSelected,
      required this.priceEtb})
      : super(key: key);

  final VoidCallback onYenepaySelected;
  final VoidCallback onCreditCardSelected;
  final VoidCallback onTelebirrSelected;
  final VoidCallback onEthioTelecomSelected;
  final VoidCallback onInAppSelected;
  final double priceEtb;

  @override
  State<DialogCompletePurchase> createState() => _DialogCompletePurchaseState();
}

class _DialogCompletePurchaseState extends State<DialogCompletePurchase>
    with TickerProviderStateMixin {
  ///TAB CONTROLLER
  late TabController _tabController;

  ///
  late bool alwaysUseSelected;
  late PaymentMethod? selectedPaymentMethod;

  @override
  void initState() {
    alwaysUseSelected = false;
    selectedPaymentMethod = null;
    BlocProvider.of<CompletePurchaseBloc>(context).add(
      LoadPaymentMethodsEvent(),
    );

    ///INIT TAB CONTROLLER
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompletePurchaseBloc, CompletePurchaseState>(
      listener: (context, state) {
        if (state is PaymentMethodsLoadedState) {
          state.availableMethods.forEach((e) {
            print(
                'state.availableMethods ${e.appPaymentMethods} ${e.isSelected} ${e.isAvailable} ');
            if (e.isSelected && e.isAvailable) {
              setState(() {
                selectedPaymentMethod = e;
              });
            }
          });
        }
      },
      child: Center(
        child: Wrap(
          children: [
            Material(
              color: Colors.transparent,
              child: Container(
                height: ScreenUtil(context: context).getScreenHeight() * 0.8,
                margin: EdgeInsets.symmetric(
                  horizontal: AppMargin.margin_16,
                ),
                decoration: BoxDecoration(
                  color: ColorMapper.getWhite(),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///BUILD DIALOG HEADER
                    buildDialogHeader(context),

                    ///BUILD PAYMENT LIST WITH TABS
                    Expanded(
                      child: BlocBuilder<CompletePurchaseBloc,
                          CompletePurchaseState>(
                        builder: (context, state) {
                          if (state is PaymentMethodsLoadedState) {
                            return buildPaymentMethods(
                              state.localAvailableMethods,
                              state.foreignAvailableMethods,
                            );
                          } else {
                            return AppLoading(
                              size: AppValues.loadingWidgetSize * 0.8,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_2,
                    ),
                    buildAlwaysSelectedCheckBox(),
                    SizedBox(
                      height: AppMargin.margin_2,
                    ),
                    buildPayButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildAlwaysSelectedCheckBox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: ColorMapper.getWhite(),
          child: Checkbox(
            value: alwaysUseSelected,
            //activeColor: ColorMapper.getDarkOrange(),
            fillColor: MaterialStateProperty.all(
              ColorMapper.getDarkOrange(),
            ),
            checkColor: ColorMapper.getWhite(),
            onChanged: (bool? value) {
              setState(() {
                alwaysUseSelected = value == null ? false : value;
              });
            },
          ),
        ),
        Text(
          AppLocale.of().alwaysUsePayment,
          style: TextStyle(
            color: ColorMapper.getTxtGrey(),
            fontWeight: FontWeight.w400,
            fontSize: AppFontSizes.font_size_8.sp,
          ),
        ),
      ],
    );
  }

  Container buildPayButton() {
    return Container(
      padding: EdgeInsets.all(
        AppPadding.padding_16,
      ),
      child: AppBouncingButton(
        onTap: () {
          ///CALL APPROPRIATE PAYMENT UTIL METHOD BASED ON SELECTED PAYMENT TYPE
          if (selectedPaymentMethod != null) {
            if (selectedPaymentMethod!.isAvailable) {
              ///POP DIALOG
              Navigator.pop(context);
              if (selectedPaymentMethod!.appPaymentMethods ==
                  AppPaymentMethods.METHOD_TELE_CARD) {
                widget.onEthioTelecomSelected();
              }
              if (selectedPaymentMethod!.appPaymentMethods ==
                  AppPaymentMethods.METHOD_INAPP) {
                widget.onInAppSelected();
              }
              if (selectedPaymentMethod!.appPaymentMethods ==
                  AppPaymentMethods.METHOD_TELEBIRR) {
                widget.onTelebirrSelected();
              }
              if (selectedPaymentMethod!.appPaymentMethods ==
                  AppPaymentMethods.METHOD_YENEPAY) {
                widget.onYenepaySelected();
              }
              if (selectedPaymentMethod!.appPaymentMethods ==
                  AppPaymentMethods.METHOD_CREDIT_CARD) {
                widget.onCreditCardSelected();
              }

              ///IF USE ALWAYS SELECTED SET PREFERRED PAYMENT TYPE
              if (alwaysUseSelected) {
                BlocProvider.of<PreferredPaymentMethodBloc>(context).add(
                  SetPreferredPaymentMethodEvent(
                    appPaymentMethods: selectedPaymentMethod!.appPaymentMethods,
                  ),
                );
              }
            }
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32,
            vertical: AppPadding.padding_16,
          ),
          decoration: BoxDecoration(
            color: selectedPaymentMethod != null
                ? selectedPaymentMethod!.isAvailable
                    ? ColorMapper.getDarkOrange()
                    : ColorMapper.getDarkGrey()
                : ColorMapper.getDarkGrey(),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().buy.toUpperCase(),
                style: TextStyle(
                  color: ColorMapper.getWhite(),
                  fontWeight: FontWeight.w600,
                  fontSize: AppFontSizes.font_size_10.sp,
                ),
              ),
              SizedBox(
                width: AppPadding.padding_8,
              ),
              Icon(
                FlutterRemix.arrow_right_s_line,
                color: ColorMapper.getWhite(),
                size: AppIconSizes.icon_size_20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethods(List<PaymentMethod> localAvailableMethods,
      List<PaymentMethod> forignAvailableMethods) {
    return Column(
      children: [
        ///BUILD TABS
        buildTabsContainer(),

        ///BUILD TAB VIEW
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildMethodsTabList(localAvailableMethods),
              buildMethodsTabList(forignAvailableMethods),
            ],
          ),
        ),
      ],
    );
  }

  ShaderMask buildMethodsTabList(List<PaymentMethod> availableMethods) {
    return ShaderMask(
      blendMode: BlendMode.dstOut,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorMapper.getBlack(),
            Colors.transparent,
            Colors.transparent,
            ColorMapper.getBlack(),
          ],
          stops: [0.0, 0.03, 0.98, 1.0],
        ).createShader(bounds);
      },
      child: Container(
        padding: EdgeInsets.all(
          AppPadding.padding_16,
        ),
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: availableMethods.length,
          padding: EdgeInsets.symmetric(vertical: AppPadding.padding_16),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: AppMargin.margin_20,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return PaymentMethodItem(
              paymentMethod: availableMethods.elementAt(index),
              onTap: () {
                if (availableMethods.elementAt(index).isAvailable) {
                  BlocProvider.of<CompletePurchaseBloc>(context).add(
                    SelectedPaymentMethodChangedEvent(
                      paymentMethod: availableMethods.elementAt(index),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Container buildTabsContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorMapper.getWhite(),
        boxShadow: [
          BoxShadow(
            color: AppColors.completelyBlack.withOpacity(0.1),
            offset: Offset(0, 3),
            blurRadius: 2,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_16, vertical: AppPadding.padding_16),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3.0,
            color: ColorMapper.getDarkOrange(),
          ),
          insets: EdgeInsets.symmetric(horizontal: 0.0),
        ),
        unselectedLabelColor: ColorMapper.getGrey(),
        labelColor: ColorMapper.getBlack(),
        labelStyle: TextStyle(
          fontSize: AppFontSizes.font_size_10.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        tabs: [
          buildTabItem(
            AppLocale.of().local.toUpperCase(),
          ),
          buildTabItem(
            AppLocale.of().foreign.toUpperCase(),
          ),
        ],
      ),
    );
  }

  buildTabItem(String text) {
    return Center(
      child: Text(
        text,
      ),
    );
  }

  Container buildDialogHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        AppPadding.padding_16,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocale.of().chooseYourPaymentMethod,
                  style: TextStyle(
                    color: ColorMapper.getBlack(),
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSizes.font_size_12.sp,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_4,
                ),
                Text(
                  AppLocale.of().chooseYourPaymentMethodMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorMapper.getTxtGrey(),
                    fontWeight: FontWeight.w400,
                    fontSize: AppFontSizes.font_size_8.sp,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AppBouncingButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                FlutterRemix.close_line,
                color: ColorMapper.getBlack(),
                size: AppIconSizes.icon_size_24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
