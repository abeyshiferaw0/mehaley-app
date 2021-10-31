import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';

class SignUpPageGradient extends StatelessWidget {
  const SignUpPageGradient({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil(context: context).getScreenWidth(),
      height: ScreenUtil(context: context).getScreenHeight(),
      decoration: BoxDecoration(
        gradient: AppGradients().getSignInPageGradient(),
      ),
    );
  }
}
