import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
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
              color: AppColors.black,
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w600,
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
