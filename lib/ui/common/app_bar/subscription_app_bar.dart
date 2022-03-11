import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_restore_bloc/iap_subscription_restore_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class SubscriptionAppBar extends StatelessWidget {
  const SubscriptionAppBar({Key? key, required this.showRestoreButton})
      : super(key: key);

  final bool showRestoreButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: AppMargin.margin_16,
        ),
        Image.asset(
          AppAssets.icAppWordIcon,
          height: AppIconSizes.icon_size_20,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: SizedBox(),
        ),
        showRestoreButton
            ? AppBouncingButton(
                onTap: () {
                  BlocProvider.of<IapSubscriptionRestoreBloc>(context).add(
                    RestoreIapSubscriptionEvent(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_12,
                    vertical: AppPadding.padding_8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      color: ColorMapper.getTxtGrey(),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FlutterRemix.refresh_line,
                        size: AppIconSizes.icon_size_12,
                        color: ColorMapper.getTxtGrey(),
                      ),
                      SizedBox(
                        width: AppMargin.margin_6,
                      ),
                      Text(
                        'Restore Purchases',
                        style: TextStyle(
                          color: ColorMapper.getBlack(),
                          fontSize: AppFontSizes.font_size_8.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(),
        SizedBox(
          width: AppMargin.margin_16,
        ),
      ],
    );
  }
}
