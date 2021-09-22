import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class ItemHomeUserLib extends StatelessWidget {
  final String text;
  final String type;
  final String imageUrl;

  ItemHomeUserLib(
      {required this.text, required this.type, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkGrey.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 6,
              spreadRadius: 6,
              color: AppColors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 35,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: AppColors.black.withOpacity(0.2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => buildItemsImagePlaceHolder(),
                  errorWidget: (context, url, error) =>
                      buildItemsImagePlaceHolder(),
                ),
              ),
            ),
            SizedBox(
              width: AppMargin.margin_8,
            ),
            Expanded(
              flex: 65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFontSizes.font_size_8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    type,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: AppFontSizes.font_size_6.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.OTHER);
  }
}
