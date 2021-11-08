import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import 'app_bouncing_button.dart';

class AppSubscribeCard extends StatelessWidget {
  const AppSubscribeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_16,
          horizontal: AppPadding.padding_16,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              AppColors.completelyBlack.withOpacity(0.3),
              BlendMode.dstATop,
            ),
            image: NetworkImage(
                'https://ichef.bbci.co.uk/news/976/cpsprodpb/68A6/production/_116609762_gettyimages-1230667435.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.subscribeDialogTitle.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_8,
            ),
            Text(
              AppLocalizations.of(context)!.subscribeDialogMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: AppColors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            AppBouncingButton(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_32,
                  vertical: AppPadding.padding_8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  AppLocalizations.of(context)!.subscribeNow.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
