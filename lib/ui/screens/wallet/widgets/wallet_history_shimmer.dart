import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/shimmer_item.dart';
import 'package:shimmer/shimmer.dart';

class WalletHistoryShimmer extends StatelessWidget {
  const WalletHistoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_16,
      ),
      child: Shimmer.fromColors(
        highlightColor: AppColors.placeholderIconColor,
        baseColor: AppColors.lightGrey,
        direction: ShimmerDirection.ltr,
        child: Wrap(
          children: [
            Column(
              children: [
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    ShimmerItem(
                      width: 50,
                      height: 50,
                      radius: 5.0,
                    ),
                    SizedBox(width: AppMargin.margin_16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: 300,
                          height: 10,
                          radius: 10,
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShimmerItem(
                              width: 68,
                              height: 10,
                              radius: 10,
                            ),
                            SizedBox(width: AppMargin.margin_16),
                            ShimmerItem(
                              width: 200,
                              height: 10,
                              radius: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    ShimmerItem(
                      width: 50,
                      height: 50,
                      radius: 5.0,
                    ),
                    SizedBox(width: AppMargin.margin_16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: 300,
                          height: 10,
                          radius: 10,
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShimmerItem(
                              width: 68,
                              height: 10,
                              radius: 10,
                            ),
                            SizedBox(width: AppMargin.margin_16),
                            ShimmerItem(
                              width: 200,
                              height: 10,
                              radius: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    ShimmerItem(
                      width: 50,
                      height: 50,
                      radius: 5.0,
                    ),
                    SizedBox(width: AppMargin.margin_16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: 300,
                          height: 10,
                          radius: 10,
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShimmerItem(
                              width: 68,
                              height: 10,
                              radius: 10,
                            ),
                            SizedBox(width: AppMargin.margin_16),
                            ShimmerItem(
                              width: 200,
                              height: 10,
                              radius: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    ShimmerItem(
                      width: 50,
                      height: 50,
                      radius: 5.0,
                    ),
                    SizedBox(width: AppMargin.margin_16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: 300,
                          height: 10,
                          radius: 10,
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShimmerItem(
                              width: 68,
                              height: 10,
                              radius: 10,
                            ),
                            SizedBox(width: AppMargin.margin_16),
                            ShimmerItem(
                              width: 200,
                              height: 10,
                              radius: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    ShimmerItem(
                      width: 50,
                      height: 50,
                      radius: 5.0,
                    ),
                    SizedBox(width: AppMargin.margin_16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: 300,
                          height: 10,
                          radius: 10,
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShimmerItem(
                              width: 68,
                              height: 10,
                              radius: 10,
                            ),
                            SizedBox(width: AppMargin.margin_16),
                            ShimmerItem(
                              width: 200,
                              height: 10,
                              radius: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    ShimmerItem(
                      width: 50,
                      height: 50,
                      radius: 5.0,
                    ),
                    SizedBox(width: AppMargin.margin_16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: 300,
                          height: 10,
                          radius: 10,
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShimmerItem(
                              width: 68,
                              height: 10,
                              radius: 10,
                            ),
                            SizedBox(width: AppMargin.margin_16),
                            ShimmerItem(
                              width: 200,
                              height: 10,
                              radius: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    ShimmerItem(
                      width: 50,
                      height: 50,
                      radius: 5.0,
                    ),
                    SizedBox(width: AppMargin.margin_16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: 300,
                          height: 10,
                          radius: 10,
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShimmerItem(
                              width: 68,
                              height: 10,
                              radius: 10,
                            ),
                            SizedBox(width: AppMargin.margin_16),
                            ShimmerItem(
                              width: 200,
                              height: 10,
                              radius: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    ShimmerItem(
                      width: 50,
                      height: 50,
                      radius: 5.0,
                    ),
                    SizedBox(width: AppMargin.margin_16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerItem(
                          width: 300,
                          height: 10,
                          radius: 10,
                        ),
                        SizedBox(height: AppMargin.margin_16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShimmerItem(
                              width: 68,
                              height: 10,
                              radius: 10,
                            ),
                            SizedBox(width: AppMargin.margin_16),
                            ShimmerItem(
                              width: 200,
                              height: 10,
                              radius: 10,
                            ),
                          ],
                        ),
                        SizedBox(height: AppMargin.margin_16),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
              ],
            )
          ],
        ),
      ),
    );
  }
}