import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
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
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(2),
        ),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 8.sp,
          color: color != null ? color : null,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
