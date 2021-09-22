import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchEmptyMessage extends StatelessWidget {
  const SearchEmptyMessage({required this.searchKey});

  final String searchKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Can't find \"${searchKey}\"",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.font_size_12.sp,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_8,
            ),
            Text(
              "Try changing your search key",
              style: TextStyle(
                color: AppColors.lightGrey,
                fontSize: AppFontSizes.font_size_8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
