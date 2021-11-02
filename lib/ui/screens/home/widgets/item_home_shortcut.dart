import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ItemHomeShortcut extends StatelessWidget {
  final String text;
  final IconData icon;
  final int textMaxLines;
  final String? shortcutType;
  final RemoteImage? image;
  final AppItemsType? appItemsType;
  final LinearGradient gradient;
  final VoidCallback onTap;

  ItemHomeShortcut({
    required this.text,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.image,
    required this.appItemsType,
    required this.textMaxLines,
    required this.shortcutType,
  });

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        child: AppCard(
          child: Row(
            children: [
              image == null ? buildIcon() : buildImage(),
              buildItemText(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildItemText() {
    return Expanded(
      flex: 65,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_8,
        ),
        color: AppColors.darkGrey.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: textMaxLines,
              style: TextStyle(
                color: AppColors.white,
                fontSize: (AppFontSizes.font_size_10 - 1).sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            shortcutType != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: AppColors.green,
                        size: AppIconSizes.icon_size_4,
                      ),
                      SizedBox(
                        width: AppMargin.margin_2,
                      ),
                      Text(
                        shortcutType!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: AppColors.txtGrey,
                          fontSize: (AppFontSizes.font_size_8 - 1).sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Expanded buildIcon() {
    return Expanded(
      flex: 35,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              color: AppColors.black.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColors.completelyBlack.withOpacity(0.0),
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: AppColors.white,
                size: AppIconSizes.icon_size_24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildImage() {
    return Expanded(
      flex: 35,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: AppApi.baseFileUrl + image!.imageSmallPath,
          fit: BoxFit.cover,
          height: AppValues.homeCategoriesItemHeight,
          width: AppValues.homeCategoriesItemWidth,
          placeholder: (context, url) =>
              buildItemsImagePlaceHolder(appItemsType!),
          errorWidget: (context, url, error) =>
              buildItemsImagePlaceHolder(appItemsType!),
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder(
      AppItemsType appItemsType) {
    return AppItemsImagePlaceHolder(appItemsType: appItemsType);
  }
}
