import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class SongItemBadge extends StatelessWidget {
  final String tag;
  final Color? color;

  const SongItemBadge({required this.tag, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: AppMargin.margin_8),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_6,
        vertical: AppPadding.padding_2,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 8.sp,
          color: color != null ? color : AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
