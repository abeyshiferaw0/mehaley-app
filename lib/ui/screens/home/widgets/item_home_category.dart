import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:sizer/sizer.dart';

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
        borderRadius: BorderRadius.circular(3),
        child: Container(
          height: AppValues.homeCategoriesItemHeight,
          width: AppValues.homeCategoriesItemWidth,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    AppApi.baseUrl + category.categoryImage.imageSmallPath,
                fit: BoxFit.cover,
                height: AppValues.homeCategoriesItemHeight,
                width: AppValues.homeCategoriesItemWidth,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => buildItemsImagePlaceHolder(),
                errorWidget: (context, url, error) =>
                    buildItemsImagePlaceHolder(),
              ),
              Container(
                color: AppColors.black.withOpacity(0.35),
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.padding_8),
                child: Center(
                  child: Text(
                    L10nUtil.translateLocale(
                      category.categoryNameText,
                      context,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
