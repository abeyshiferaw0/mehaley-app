import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/screens/home/widgets/item_home_user_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class HomeUserLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppMargin.margin_16),
          child: Text(
            "Good Morning",
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.font_size_16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: AppMargin.margin_16,
            right: AppMargin.margin_16,
          ),
          child: GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: (3.3 / 1.1),
            crossAxisSpacing: AppMargin.margin_8,
            mainAxisSpacing: AppMargin.margin_8,
            crossAxisCount: 2,
            children: [
              ItemHomeUserLib(
                text: "Purchased",
                icon: PhosphorIcons.shopping_cart_simple_fill,
                gradient: AppGradients().getOfflineLibraryGradient(),
                onTap: () {},
              ),
              ItemHomeUserLib(
                text: "Offline",
                icon: PhosphorIcons.caret_circle_down_fill,
                gradient: AppGradients().getPurchasedLibraryGradient(),
                onTap: () {},
              ),
            ],
          ),
        )
      ],
    );
  }
}
