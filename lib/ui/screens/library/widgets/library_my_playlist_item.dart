import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class LibraryMyPlaylistItem extends StatelessWidget {
  final bool isCreatePlaylistButton;

  const LibraryMyPlaylistItem({
    required this.isCreatePlaylistButton,
  });

  @override
  Widget build(BuildContext context) {
    if (isCreatePlaylistButton) {
      return buildCreatePlaylistButton(context);
    } else {
      return buildPlaylistItem();
    }
  }

  AppBouncingButton buildCreatePlaylistButton(context) {
    return AppBouncingButton(
      onTap: () {
        Navigator.pushNamed(context, AppRouterPaths.createPlaylistRoute);
      },
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppCard(
              child: Container(
                width: AppValues.libraryMusicItemSize,
                height: AppValues.libraryMusicItemSize,
                color: AppColors.darkGrey,
                child: Icon(
                  PhosphorIcons.plus_light,
                  color: AppColors.white,
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ),
            SizedBox(width: AppMargin.margin_16),
            Expanded(
              child: Text(
                "Create New playlist",
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildPlaylistItem() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppCard(
            child: CachedNetworkImage(
              width: AppValues.libraryMusicItemSize,
              height: AppValues.libraryMusicItemSize,
              fit: BoxFit.cover,
              imageUrl:
                  "https://st3.depositphotos.com/1047356/14593/i/950/depositphotos_145937553-stock-photo-religious-christian-cross-with-sunset.jpg",
              placeholder: (context, url) => buildImagePlaceHolder(),
              errorWidget: (context, url, e) => buildImagePlaceHolder(),
            ),
          ),
          SizedBox(width: AppMargin.margin_16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Liked Mezmurs",
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: AppMargin.margin_2),
                Text(
                  "24 mezmurs",
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_14,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.PLAYLIST);
}
