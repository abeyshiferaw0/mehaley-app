import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LibraryEmptyPage extends StatelessWidget {
  const LibraryEmptyPage({
    Key? key,
    required this.icon,
    required this.msg,
  }) : super(key: key);

  final IconData icon;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppIconSizes.icon_size_72,
            color: AppColors.darkGrey.withOpacity(0.8),
          ),
          SizedBox(
            height: AppMargin.margin_8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_20,
            ),
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: AppColors.txtGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
