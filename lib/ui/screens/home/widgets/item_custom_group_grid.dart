import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ItemCustomGroupGrid extends StatelessWidget {
  final dynamic item;
  final GroupType groupType;
  final VoidCallback onTap;

  ItemCustomGroupGrid({
    required this.item,
    required this.groupType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                groupType == GroupType.ARTIST
                    ? AppValues.customGroupItemSize
                    : 0,
              ),
              child: CachedNetworkImage(
                //height: AppValues.customGroupItemSize,
                width: groupType == GroupType.ARTIST
                    ? AppValues.customGroupItemSize
                    : double.infinity,
                fit: BoxFit.cover,
                //height: AppValues.customGroupItemSize,
                imageUrl: PagesUtilFunctions.getGroupImageUrl(groupType, item),
                placeholder: (context, url) => buildItemsImagePlaceHolder(),
                errorWidget: (context, url, error) =>
                    buildItemsImagePlaceHolder(),
                imageBuilder: (context, imageProvider) => Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    groupType != GroupType.ARTIST
                        ? AppIconWidget()
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AppMargin.margin_8),
          Text(
            PagesUtilFunctions.getGroupItemTitle(groupType, item, context),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
              fontSize: AppFontSizes.font_size_10.sp,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_2,
          ),
          PagesUtilFunctions.getGroupItemPrice(groupType, item)
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(
        appItemsType:
            PagesUtilFunctions.getGroupItemImagePlaceHolderType(groupType));
  }
}
