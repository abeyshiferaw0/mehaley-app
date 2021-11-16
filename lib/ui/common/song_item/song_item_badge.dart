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
        horizontal: AppPadding.padding_4,
        vertical: 1.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        border: Border.all(
          color: AppColors.txtGrey.withOpacity(0.7),
          width: 0.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 6.sp,
          color: color != null ? color : AppColors.txtGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
