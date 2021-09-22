import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/shimmer_item.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryTopShimmer extends StatelessWidget {
  const CategoryTopShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        highlightColor: Color(0xff313131),
        baseColor: Color(0xff262626),
        direction: ShimmerDirection.ltr,
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppMargin.margin_32),
                ShimmerItem(
                  width: 150,
                  height: 20,
                  radius: 10.0,
                ),
                SizedBox(height: AppMargin.margin_48),
                Wrap(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: AppMargin.margin_16),
                        ShimmerItem(
                          width: 120,
                          height: 120,
                          radius: 0.0,
                        ),
                        SizedBox(width: AppMargin.margin_16),
                        ShimmerItem(
                          width: 120,
                          height: 120,
                          radius: 0.0,
                        ),
                        SizedBox(width: AppMargin.margin_16),
                        ShimmerItem(
                          width: 120,
                          height: 120,
                          radius: 0.0,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_48),
                ShimmerItem(
                  width: 150,
                  height: 20,
                  radius: 10.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
