import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class CartSummery extends StatelessWidget {
  const CartSummery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: AppMargin.margin_16),
          Text(
            AppLocalizations.of(context)!.cartSummery,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
          Padding(
            padding: const EdgeInsets.only(
              left: AppPadding.padding_16,
              right: AppPadding.padding_16,
            ),
            child: Divider(
              height: 1,
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
        ],
      ),
    );
  }
}
