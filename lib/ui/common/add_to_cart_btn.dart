import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class AddToCartBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_16,
          vertical: AppPadding.padding_8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: AppColors.lightGrey,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppPadding.padding_2),
              child: Icon(
                PhosphorIcons.shopping_cart_simple_light,
                size: AppIconSizes.icon_size_20,
              ),
            ),
            SizedBox(width: AppMargin.margin_8),
            Text(
              "ADD TO CART",
              style: TextStyle(
                fontSize: AppFontSizes.font_size_14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
