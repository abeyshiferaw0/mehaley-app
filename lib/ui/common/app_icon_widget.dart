import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5),
      child: SvgPicture.asset(
        'assets/icons/ic_app.svg',
        width: AppIconSizes.icon_size_20,
        color: AppColors.black,
      ),
    );
  }
}
