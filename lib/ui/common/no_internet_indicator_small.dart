import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoInternetIndicatorSmall extends StatefulWidget {
  const NoInternetIndicatorSmall({Key? key}) : super(key: key);

  @override
  _NoInternetIndicatorSmallState createState() =>
      _NoInternetIndicatorSmallState();
}

class _NoInternetIndicatorSmallState extends State<NoInternetIndicatorSmall>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    //BlocProvider.of<ConnectivityCubit>(context).checkConnectivity();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
        .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: SlideTransition(
        position: offset,
        child: Wrap(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.black,
              padding: EdgeInsets.symmetric(vertical: AppPadding.padding_4),
              child: Center(
                child: Text(
                  AppLocale.of().noInternetMsg,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
