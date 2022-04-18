import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';

class AppImageTint extends StatelessWidget {
  const AppImageTint({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.completelyBlack.withOpacity(0.2),
    );
  }
}
