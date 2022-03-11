import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/ui/screens/home/widgets/item_home_category.dart';
import 'package:sizer/sizer.dart';

class HomeCategories extends StatelessWidget {
  final List<Category> categories;

  const HomeCategories({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppMargin.margin_16),
          child: Text(
            AppLocale.of().categories,
            style: TextStyle(
              color: ColorMapper.getBlack(),
              fontSize: AppFontSizes.font_size_16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buildCategoryItems(categories),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> buildCategoryItems(List<Category> categories) {
    final items = <Widget>[];

    if (categories.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < categories.length; i++) {
        items.add(
          ItemHomeCategory(
            category: categories[i],
          ),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_16,
          ),
        );
      }
    }

    return items;
  }
}
