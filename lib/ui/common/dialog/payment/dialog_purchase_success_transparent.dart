import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogPurchaseSuccess extends StatefulWidget {
  const DialogPurchaseSuccess({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;

  @override
  State<DialogPurchaseSuccess> createState() => _DialogPurchaseSuccessState();
}

class _DialogPurchaseSuccessState extends State<DialogPurchaseSuccess>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            width: ScreenUtil(context: context).getScreenWidth() * 0.8,
            decoration: BoxDecoration(
              color: AppColors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  AppAssets.successLottieTwo,
                  controller: _controller,
                  width: ScreenUtil(context: context).getScreenWidth() * 0.5,
                  height: ScreenUtil(context: context).getScreenWidth() * 0.5,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                  repeat: false,
                  fit: BoxFit.contain,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_8,
                ),
                Text(
                  widget.subTitle,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
