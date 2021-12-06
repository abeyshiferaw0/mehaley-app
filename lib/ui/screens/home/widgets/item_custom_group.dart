import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class ItemCustomGroup extends StatelessWidget {
  final double width;
  final double height;
  final dynamic item;
  final GroupType groupType;
  final VoidCallback onTap;

  ItemCustomGroup({
    required this.width,
    required this.height,
    required this.groupType,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.only(top: AppMargin.margin_16),
        child: Column(
          crossAxisAlignment: groupType == GroupType.ARTIST
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  groupType == GroupType.ARTIST ? width : 0),
              child: CachedNetworkImage(
                imageUrl: PagesUtilFunctions.getGroupImageUrl(groupType, item),
                width: width,
                height: height,
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
                placeholder: (context, url) => buildItemsImagePlaceHolder(),
                errorWidget: (context, url, error) =>
                    buildItemsImagePlaceHolder(),
              ),
            ),
            SizedBox(
              height: groupType == GroupType.ARTIST
                  ? AppMargin.margin_8
                  : AppMargin.margin_6,
            ),
            Text(
              PagesUtilFunctions.getGroupItemTitle(groupType, item, context),
              maxLines: 2,
              textAlign: groupType == GroupType.ARTIST
                  ? TextAlign.center
                  : TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: PagesUtilFunctions.getGroupItemTextStyle(groupType, item),
            ),
            PagesUtilFunctions.getGroupItemPrice(groupType, item),
            PagesUtilFunctions.getIsExplicitTag(groupType, item)
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(
        appItemsType:
            PagesUtilFunctions.getGroupItemImagePlaceHolderType(groupType));
  }
}
