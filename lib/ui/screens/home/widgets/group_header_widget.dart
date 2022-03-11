import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:sizer/sizer.dart';

class GroupHeaderWidget extends StatelessWidget {
  const GroupHeaderWidget({
    Key? key,
    required this.groupHeaderImageUrl,
    required this.groupSubTitle,
    required this.groupTitle,
  }) : super(key: key);

  final String? groupHeaderImageUrl;
  final String? groupSubTitle;
  final String groupTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppMargin.margin_16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(AppValues.customGroupHeaderImageSize),
            ),
            child: CachedNetworkImage(
              width: AppValues.customGroupHeaderImageSize,
              height: AppValues.customGroupHeaderImageSize,
              fit: BoxFit.cover,
              imageUrl:
                  groupHeaderImageUrl != null ? '$groupHeaderImageUrl' : '',
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  buildImagePlaceHolder(),
              errorWidget: (context, url, error) => buildImagePlaceHolder(),
            ),
          ),
          SizedBox(width: AppMargin.margin_8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupSubTitle != null ? groupSubTitle!.toTitleCase() : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorMapper.getGrey(),
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  groupTitle.toTitleCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorMapper.getBlack(),
                    fontSize: AppFontSizes.font_size_14.sp,
                    fontWeight: FontWeight.bold,
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
