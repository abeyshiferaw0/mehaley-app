import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/shimmer_item.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAlbum extends StatelessWidget {
  const ShimmerAlbum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SCREEN WIDTH
    var screenWidth = ScreenUtil(context: context).getScreenWidth();

    return SafeArea(
      child: Shimmer.fromColors(
        highlightColor: AppColors.darkGrey,
        baseColor: Color(0xff262626),
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
