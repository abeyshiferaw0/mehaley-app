import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/enums/app_payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.scale,
    required this.isSelected,
    required this.appPaymentMethods,
    required this.onTap,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final double scale;
  final bool isSelected;
  final AppPaymentMethods appPaymentMethods;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
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
