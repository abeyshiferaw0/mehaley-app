import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class AppError extends StatefulWidget {
  const AppError(
      {Key? key, required this.onRetry, required this.bgWidget, this.height})
      : super(key: key);

  final VoidCallback onRetry;
  final Widget bgWidget;
  final double? height;

  @override
  _AppErrorState createState() => _AppErrorState();
}

class _AppErrorState extends State<AppError> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height != null ? widget.height : double.infinity,
      child: Stack(
        children: [
          widget.bgWidget,
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.padding_16,
                      vertical: AppPadding.padding_16,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: AppMargin.margin_16,
                      vertical: AppMargin.margin_16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppPadding.padding_8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          child: Lottie.asset(
                            "assets/lottie/no_internet.json",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: AppMargin.margin_4),
                        Text(
                          "No internet connection",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_12.sp,
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: AppMargin.margin_8),
                        Text(
                          "You don't have a working internet connection, Check your internet connection",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_10.sp,
                            color: AppColors.txtGrey,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        GestureDetector(
                          onTap: () {
                            _controller
                                .reverse()
                                .then((value) => widget.onRetry());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.darkGreen,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 0),
                                    color: AppColors.black.withOpacity(0.2),
                                    blurRadius: 6)
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.padding_32,
                              vertical: AppPadding.padding_8,
                            ),
                            child: Text(
                              "TRY AGAIN",
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_10.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
