import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    Key? key,
    required this.paymentMethod,
    required this.onTap,
  }) : super(key: key);

  final PaymentMethod paymentMethod;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        if (paymentMethod.isAvailable) {
          onTap();
        }
      },
      disableBouncing: !paymentMethod.isAvailable,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppPadding.padding_16),
        decoration: BoxDecoration(
          color: !paymentMethod.isAvailable ? AppColors.lightGrey : null,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: paymentMethod.isSelected
                ? AppColors.darkOrange
                : AppColors.txtGrey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            SizedBox(
              height: AppMargin.margin_20,
            ),
            buildTitleText(),
            SizedBox(
              height: AppMargin.margin_20,
            ),
            buildDescriptionText(),
            buildOtherPaymentOptionsImages(),
          ],
        ),
      ),
    );
  }

  Widget buildOtherPaymentOptionsImages() {
    if (paymentMethod.paymentOptionImages.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: AppMargin.margin_32),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: getOtherOptionsImages(),
          ),
        ),
      );
    }
    return SizedBox();
  }

  Text buildDescriptionText() {
    return Text(
      paymentMethod.description,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_8.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.txtGrey,
      ),
    );
  }

  Text buildTitleText() {
    return Text(
      paymentMethod.title,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_12.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }

  Row buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          paymentMethod.paymentMethodImage.imagePath,
          height: paymentMethod.paymentMethodImage.height,
        ),
        paymentMethod.isSelected
            ? Icon(
                FlutterRemix.checkbox_circle_fill,
                size: AppIconSizes.icon_size_24,
                color: AppColors.darkOrange,
              )
            : Icon(
                FlutterRemix.checkbox_blank_circle_line,
                size: AppIconSizes.icon_size_24,
                color: AppColors.lightGrey,
              ),
      ],
    );
  }

  List<Widget> getOtherOptionsImages() {
    List<Widget> widgets = [];

    for (var i = 0; i < paymentMethod.paymentOptionImages.length; i++) {
      widgets.add(
        AppCard(
          radius: 3,
          withShadow: false,
          child: Image.asset(
            paymentMethod.paymentOptionImages[i].imagePath,
            height: paymentMethod.paymentOptionImages[i].height,
          ),
        ),
      );
      widgets.add(
        SizedBox(width: AppMargin.margin_12),
      );
    }
    return widgets;
  }
}
