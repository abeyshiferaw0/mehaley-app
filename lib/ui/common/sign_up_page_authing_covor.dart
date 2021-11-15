import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/util/screen_util.dart';

class SignUpPageAuthingCovor extends StatelessWidget {
  const SignUpPageAuthingCovor({
    Key? key,
    required this.showLoading,
  }) : super(key: key);

  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil(context: context).getScreenWidth(),
      height: ScreenUtil(context: context).getScreenHeight(),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.5),
      ),
      child: showLoading
          ? Center(
              child: AppLoading(
                size: AppValues.loadingWidgetSize,
              ),
            )
          : SizedBox(),
    );
  }
}
