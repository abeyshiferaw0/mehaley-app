import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/dialog/dialog_clear_cart.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:sizer/sizer.dart';

class ClearAndCheckDelegate extends SliverPersistentHeaderDelegate {
  ClearAndCheckDelegate();

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    var opacityPercentage = shrinkOffset / 120;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorUtil.darken(AppColors.darkOrange, 0.3).withOpacity(
              opacityPercentage < 0.2 ? 0.2 : opacityPercentage,
            ),
            AppColors.white,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ClearAllButton(),
              ),
              SizedBox(
                width: AppMargin.margin_32,
              ),
              Expanded(
                child: CheckOutButton(opacityPercentage: opacityPercentage),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class CheckOutButton extends StatelessWidget {
  const CheckOutButton({
    Key? key,
    required this.opacityPercentage,
  }) : super(key: key);

  final double opacityPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_8,
      ),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocale.of().checkOut.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              color: ColorUtil.darken(
                AppColors.darkOrange,
                1 - opacityPercentage,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: AppMargin.margin_2,
          ),
          Icon(
            FlutterRemix.arrow_right_line,
            color: ColorUtil.darken(
              AppColors.darkOrange,
              1 - opacityPercentage,
            ),
            size: AppIconSizes.icon_size_16,
          ),
        ],
      ),
    );
  }
}

class ClearAllButton extends StatelessWidget {
  const ClearAllButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return Center(
              child: DialogClearCart(
                mainButtonText: AppLocale.of().clearAll.toUpperCase(),
                cancelButtonText: AppLocale.of().cancel.toUpperCase(),
                titleText: AppLocale.of().areYouSureUWantToClearCart,
                onClear: () {
                  BlocProvider.of<CartUtilBloc>(context).add(
                    ClearAllCartEvent(),
                  );
                },
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.black,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            AppLocale.of().clearAll.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
