import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import '../app_bouncing_button.dart';

class PreferredPaymentDialog extends StatelessWidget {
  const PreferredPaymentDialog({Key? key}) : super(key: key);

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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.all(
              AppPadding.padding_16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDialogHeader(context),
                SizedBox(
                  height: AppMargin.margin_32,
                ),
                buildPaymentMethodsList(),
                SizedBox(
                  height: AppMargin.margin_20,
                ),
                Text(
                  "Currently Selected".toUpperCase(),
                  style: TextStyle(
                    color: AppColors.txtGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSizes.font_size_8.sp,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_16,
                ),
                PaymentMethodItem(
                  title: 'Hello Cash',
                  imagePath: "assets/images/ic_hello_cash.png",
                  scale: 0.8,
                  isSelected: true,
                ),
                SizedBox(
                  height: AppMargin.margin_20,
                ),
                buildSaveButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildSaveButton() => Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_32,
          vertical: AppPadding.padding_20,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            "Change Payment Method".toUpperCase(),
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: AppFontSizes.font_size_10.sp,
            ),
          ),
        ),
      );

  Expanded buildPaymentMethodsList() {
    return Expanded(
      child: ShaderMask(
        blendMode: BlendMode.dstOut,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              Colors.transparent,
              Colors.transparent,
              AppColors.white,
            ],
            stops: [0.0, 0.03, 0.98, 1.0],
          ).createShader(bounds);
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: 'Amole',
                imagePath: "assets/images/ic_amole.png",
                scale: 1.0,
                isSelected: false,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: 'CBE Birr',
                imagePath: "assets/images/ic_cbe_birr.png",
                scale: 1.0,
                isSelected: false,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: 'Hello Cash',
                imagePath: "assets/images/ic_hello_cash.png",
                scale: 0.8,
                isSelected: false,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: 'Mbirr',
                imagePath: "assets/images/ic_mbirr.png",
                scale: 1.3,
                isSelected: false,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: 'Visa',
                imagePath: "assets/images/ic_visa.png",
                scale: 1.0,
                isSelected: false,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: 'Mastercard',
                imagePath: "assets/images/ic_mastercard.png",
                scale: 1.0,
                isSelected: false,
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
            ],
          ),
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
              "Payment Methods",
              style: TextStyle(
                color: AppColors.black,
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
                PhosphorIcons.x_light,
                color: AppColors.black,
                size: AppIconSizes.icon_size_24,
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Text(
          "Select your preferred payment method for all purchases, you can change it at any time",
          style: TextStyle(
            color: AppColors.txtGrey,
            fontWeight: FontWeight.w400,
            fontSize: AppFontSizes.font_size_8.sp,
          ),
        ),
      ],
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.scale,
    required this.isSelected,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final double scale;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_8,
          horizontal: AppPadding.padding_16,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? AppColors.darkGreen
                : AppColors.grey.withOpacity(0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGrey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 60,
                height: 50,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: AppMargin.margin_12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: AppFontSizes.font_size_12.sp,
                    ),
                  ),
                  Text(
                    "Some message for sub title message sub title message",
                    style: TextStyle(
                      color: AppColors.txtGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: AppFontSizes.font_size_8.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppMargin.margin_8),
            isSelected
                ? Icon(
                    PhosphorIcons.check_circle_fill,
                    color: AppColors.darkGreen,
                    size: AppIconSizes.icon_size_24,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
