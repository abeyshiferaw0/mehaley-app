import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';

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
        color: AppColors.completelyBlack.withOpacity(0.5),
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
