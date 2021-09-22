import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';

class BuyPlaylistBtnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: AppColors.lightGrey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "BUY ALL SONGS IN PLAYLIST",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(width: AppMargin.margin_4),
          Text(
            "\$3.22",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.darkGreen.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.lineThrough,
              fontSize: AppFontSizes.font_size_16,
            ),
          ),
          SizedBox(width: AppMargin.margin_4),
          Text(
            "\$3.22",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.font_size_16,
            ),
          )
        ],
      ),
    );
  }
}
