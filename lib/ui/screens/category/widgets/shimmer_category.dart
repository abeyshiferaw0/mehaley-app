import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/shimmer_item.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        highlightColor: ColorMapper.getPlaceholderIconColor(),
        baseColor: ColorMapper.getLightGrey(),
        direction: ShimmerDirection.ltr,
        child: Wrap(
          children: [
            Column(
              children: getShimmers(30),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getShimmers(int size) {
    List<Widget> shimmers = [];

    for (var i = 0; i < size; i++) {
      shimmers.add(
        Column(
          children: [
            Row(
              children: [
                ShimmerItem(
                  width: 50,
                  height: 50,
                  radius: 5.0,
                ),
                SizedBox(width: AppMargin.margin_16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerItem(
                        height: 10,
                        radius: 10,
                        width: double.infinity,
                      ),
                      SizedBox(height: AppMargin.margin_16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ShimmerItem(
                              width: double.infinity,
                              height: 10,
                              radius: 10,
                            ),
                          ),
                          SizedBox(width: AppMargin.margin_16),
                          Expanded(
                            flex: 7,
                            child: ShimmerItem(
                              width: double.infinity,
                              height: 10,
                              radius: 10,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppMargin.margin_16),
          ],
        ),
      );
    }

    return shimmers;
  }
}
