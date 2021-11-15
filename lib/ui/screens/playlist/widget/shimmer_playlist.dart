import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/shimmer_item.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaylist extends StatelessWidget {
  const ShimmerPlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SCREEN WIDTH
    var screenWidth = ScreenUtil(context: context).getScreenWidth();

    return SafeArea(
      child: Shimmer.fromColors(
        highlightColor: AppColors.lightGrey,
        baseColor: AppColors.txtGrey,
        direction: ShimmerDirection.ltr,
        child: Wrap(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: AppMargin.margin_32),
                  ShimmerItem(
                    width: 190,
                    height: 200,
                    radius: 0.0,
                  ),
                  SizedBox(height: AppMargin.margin_16),
                  ShimmerItem(
                    width: 130,
                    height: 15,
                    radius: 10.0,
                  ),
                  SizedBox(height: AppMargin.margin_16),
                  ShimmerItem(
                    width: 100,
                    height: 15,
                    radius: 10.0,
                  ),
                  SizedBox(height: 60),
                  ShimmerItem(
                    width: 160,
                    height: 30,
                    radius: 15.0,
                  ),
                  SizedBox(height: 80),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: AppMargin.margin_16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: screenWidth / 2,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                        SizedBox(height: AppMargin.margin_28),
                        ShimmerItem(
                          width: screenWidth,
                          height: 15,
                          radius: 10.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
