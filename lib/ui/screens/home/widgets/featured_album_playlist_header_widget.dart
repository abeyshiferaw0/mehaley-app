import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:sizer/sizer.dart';

class FeaturedAlbumPlaylistHeaderWidget extends StatelessWidget {
  const FeaturedAlbumPlaylistHeaderWidget({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppMargin.margin_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: title.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
                color: ColorMapper.getDarkOrange(),
                letterSpacing: 0.2,
              ),
              children: [
                TextSpan(
                  text: '\n$subTitle',
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_16.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorMapper.getBlack(),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ALBUM);
}
