import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:sizer/sizer.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:flutter/material.dart';

class CartHorizontalItem extends StatelessWidget {
  final double width;
  final double price;
  final String title;
  final String subTitle;
  final String imageUrl;

  CartHorizontalItem({
    required this.width,
    required this.price,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: width,
                height: width,
                imageBuilder: (context, imageProvider) => Stack(
                  children: [
                    Container(
                      width: width,
                      height: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    AppIconWidget()
                  ],
                ),
                placeholder: (context, url) => buildItemsImagePlaceHolder(),
                errorWidget: (context, url, error) =>
                    buildItemsImagePlaceHolder(),
              ),
            ),
            SizedBox(
              height: AppMargin.margin_6,
            ),
            Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            Text(
              subTitle,
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
                fontSize: AppFontSizes.font_size_8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
