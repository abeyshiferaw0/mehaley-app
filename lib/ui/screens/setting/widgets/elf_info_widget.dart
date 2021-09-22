import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ElfInfoWidget extends StatelessWidget {
  const ElfInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppMargin.margin_20),
      child: Column(
        children: [
          Text(
            "elf play",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          Text(
            "version 1.0.0",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Text(
            "Some text about elf and terms and conditions and privacy policy, Some text about elf and terms and conditions and privacy policy ,Some text about elf and terms and conditions and privacy policy",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
        ],
      ),
    );
  }
}
