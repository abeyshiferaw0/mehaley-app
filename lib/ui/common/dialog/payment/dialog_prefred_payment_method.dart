import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/preferred_payment_method_bloc/preferred_payment_method_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/dialog/widgets/payment_item.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';

class PreferredPaymentDialog extends StatefulWidget {
  const PreferredPaymentDialog({Key? key}) : super(key: key);

  @override
  State<PreferredPaymentDialog> createState() => _PreferredPaymentDialogState();
}

class _PreferredPaymentDialogState extends State<PreferredPaymentDialog> {
  @override
  void initState() {
    BlocProvider.of<PreferredPaymentMethodBloc>(context).add(
      LoadPreferredPaymentMethodEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.8,
            margin: EdgeInsets.symmetric(
              horizontal: AppMargin.margin_16,
            ),
            decoration: BoxDecoration(
              color: ColorMapper.getWhite(),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.all(
              AppPadding.padding_16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDialogHeader(context),
                Expanded(
                  child: BlocBuilder<PreferredPaymentMethodBloc,
                      PreferredPaymentMethodState>(
                    builder: (context, state) {
                      if (state is PreferredPaymentMethodLoadedState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: AppMargin.margin_16,
                            ),
                            buildPaymentMethodsList(state.availableMethods),
                            SizedBox(
                              height: AppMargin.margin_16,
                            ),
                          ],
                        );
                      } else {
                        return AppLoading(
                          size: AppValues.loadingWidgetSize * 0.8,
                        );
                      }
                    },
                  ),
                ),
                buildDoneButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBouncingButton buildDoneButton() => AppBouncingButton(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32,
            vertical: AppPadding.padding_20,
          ),
          decoration: BoxDecoration(
            color: ColorMapper.getDarkOrange(),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              AppLocale.of().done.toUpperCase(),
              style: TextStyle(
                color: ColorMapper.getWhite(),
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
          ),
        ),
      );

  Expanded buildPaymentMethodsList(List<PaymentMethod> availableMethods) {
    return Expanded(
      child: ShaderMask(
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
                BlocProvider.of<PreferredPaymentMethodBloc>(context).add(
                  SetPreferredPaymentMethodEvent(
                    appPaymentMethods:
                        availableMethods.elementAt(index).appPaymentMethods,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Column buildDialogHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().preferredPaymentMethod,
              style: TextStyle(
                color: ColorMapper.getBlack(),
                fontWeight: FontWeight.w500,
                fontSize: AppFontSizes.font_size_12.sp,
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            AppBouncingButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                FlutterRemix.close_line,
                color: ColorMapper.getBlack(),
                size: AppIconSizes.icon_size_24,
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Text(
          AppLocale.of().selectYourPrefrredPayment,
          style: TextStyle(
            color: ColorMapper.getTxtGrey(),
            fontWeight: FontWeight.w400,
            fontSize: AppFontSizes.font_size_8.sp,
          ),
        ),
      ],
    );
  }
}
