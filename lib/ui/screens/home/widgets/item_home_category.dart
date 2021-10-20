import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/config/themes.dart';
import 'package:sizer/sizer.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/material.dart';import 'package:elf_play/util/l10n_util.dart';

class ItemHomeCategory extends StatelessWidget {
  final Category category;

  const ItemHomeCategory({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouterPaths.categoryRoute,
          arguments: ScreenArguments(args: {'category': category}),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Container(
          height: AppValues.homeCategoriesItemHeight,
          width: AppValues.homeCategoriesItemWidth,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    AppApi.baseFileUrl + category.categoryImage.imageSmallPath,
                fit: BoxFit.cover,
                height: AppValues.homeCategoriesItemHeight,
                width: AppValues.homeCategoriesItemWidth,
                placeholder: (context, url) => buildItemsImagePlaceHolder(),
                errorWidget: (context, url, error) =>
                    buildItemsImagePlaceHolder(),
              ),
              Container(
                height: AppValues.homeCategoriesItemHeight,
                width: AppValues.homeCategoriesItemWidth,
                color: AppColors.black.withOpacity(0.6),
              ),
              Center(
                child: Text(
                    L10nUtil.translateLocale( category.categoryNameText, context),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.OTHER);
  }
}
