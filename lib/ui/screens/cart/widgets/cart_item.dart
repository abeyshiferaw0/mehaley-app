import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/song_item/song_item_badge.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    Key? key,
    required this.itemKey,
    required this.item,
    required this.title,
    required this.subTitle,
    required this.imagePath,
  }) : super(key: key);

  final Key itemKey;
  final dynamic item;
  final String title;
  final String imagePath;
  final String subTitle;

  @override
  _CartItemState createState() => _CartItemState(
        itemKey: itemKey,
        item: item,
        title: title,
        subTitle: subTitle,
        imagePath: imagePath,
      );
}

class _CartItemState extends State<CartItem> {
  _CartItemState({
    required this.item,
    required this.itemKey,
    required this.title,
    required this.imagePath,
    required this.subTitle,
  });

  final Key itemKey;
  final dynamic item;
  final String title;
  final String imagePath;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {},
      child: buildListItem(context),
    );
  }

  Container buildListItem(BuildContext context) {
    return Container(
      key: itemKey,
      margin: EdgeInsets.only(
        bottom: AppMargin.margin_8,
        top: AppMargin.margin_8,
      ),
      child: Row(
        children: [
          AppCard(
            child: CachedNetworkImage(
              width: AppValues.queueSongItemSize,
              height: AppValues.queueSongItemSize,
              fit: BoxFit.cover,
              imageUrl: AppApi.baseFileUrl + imagePath,
              placeholder: (context, url) => buildImagePlaceHolder(),
              errorWidget: (context, url, e) => buildImagePlaceHolder(),
            ),
          ),
          SizedBox(width: AppMargin.margin_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_2,
                ),
                Row(
                  children: [
                    SongItemBadge(
                      tag: "3.00",
                      color: AppColors.darkGreen,
                    ),
                    SongItemBadge(
                      tag: "MEZMUR",
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.txtGrey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          AppBouncingButton(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(AppPadding.padding_8),
              child: CircleAvatar(
                backgroundColor: AppColors.green.withOpacity(0.2),
                radius: AppMargin.margin_12,
                child: Icon(
                  PhosphorIcons.x_light,
                  color: AppColors.lightGrey,
                  size: AppIconSizes.icon_size_12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}
