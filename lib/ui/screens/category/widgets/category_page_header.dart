import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import 'category_header_gradient.dart';

class CategoryPageHeader extends StatefulWidget {
  const CategoryPageHeader({
    required this.shrinkPercentage,
    required this.category,
  });

  final double shrinkPercentage;
  final Category category;

  @override
  _CategoryPageHeaderState createState() => _CategoryPageHeaderState();
}

class _CategoryPageHeaderState extends State<CategoryPageHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          fit: BoxFit.cover,
          height: 360,
          width: double.infinity,
          imageUrl: AppApi.baseFileUrl + widget.category.categoryImage.imageMediumPath,
          placeholder: (context, url) => buildCategoryHeaderGradient(),
          errorWidget: (context, url, e) => buildCategoryHeaderGradient(),
        ),
        Container(
          height: 360,
          decoration: BoxDecoration(
            gradient: AppGradients().getCategoryFilterGradient(AppColors.appGradientDefaultColor),
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                buildAppBar(widget.shrinkPercentage, widget.category),
                Opacity(
                  opacity: 1 - widget.shrinkPercentage,
                  child: buildCategoryInfo(widget.category),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(double shrinkPercentage, Category category) {
    return AppBar(
      //brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          PhosphorIcons.caret_left_light,
          size: AppIconSizes.icon_size_24,
          color: AppColors.white,
        ),
      ),
      title: Opacity(
        opacity: widget.shrinkPercentage,
        child: Text(
          L10nUtil.translateLocale(category.categoryNameText, context),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget buildCategoryInfo(Category category) {
    return Transform.scale(
      scale: (1 - widget.shrinkPercentage),
      child: Transform.translate(
        //scale: (1 - widget.shrinkPercentage),
        //angle: (1 - widget.shrinkPercentage),
        offset: Offset(0, (widget.shrinkPercentage) * 50),
        child: Container(
          height: AppValues.categoryHeaderHeight - 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
                child: Text(
                  L10nUtil.translateLocale(category.categoryNameText, context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: AppFontSizes.font_size_24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

CategoryHeaderGradient buildCategoryHeaderGradient() {
  return CategoryHeaderGradient(
    height: AppValues.categoryHeaderHeight,
    color: AppColors.appGradientDefaultColor,
  );
}
