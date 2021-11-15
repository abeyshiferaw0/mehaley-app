import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:sizer/sizer.dart';

class SearchFrontPageItems extends StatefulWidget {
  const SearchFrontPageItems({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.appItemType,
    required this.dominantColor,
    required this.onTap,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final AppItemsType appItemType;
  final Color dominantColor;
  final VoidCallback onTap;

  @override
  _SearchFrontPageItemsState createState() => _SearchFrontPageItemsState();
}

class _SearchFrontPageItemsState extends State<SearchFrontPageItems> {
  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.dominantColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: AppMargin.margin_8,
              top: AppMargin.margin_8,
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 100),
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: widget.appItemType == AppItemsType.ARTIST ? -10 : -5,
              right: -10,
              child: Transform.rotate(
                angle: -math.pi / -9.0,
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-4, -3),
                        blurRadius: 8,
                        spreadRadius: 3,
                        color: AppColors.white.withOpacity(0.25),
                      ),
                    ],
                    borderRadius: widget.appItemType == AppItemsType.ARTIST
                        ? BorderRadius.circular(
                            AppValues.searchFrontPageItemsImageSize)
                        : BorderRadius.circular(2),
                  ),
                  child: Container(
                    height: AppValues.searchFrontPageItemsImageSize,
                    width: AppValues.searchFrontPageItemsImageSize,
                    child: CachedNetworkImage(
                      height: AppValues.searchFrontPageItemsImageSize,
                      width: AppValues.searchFrontPageItemsImageSize,
                      imageUrl: widget.imageUrl,
                      errorWidget: (context, error, url) =>
                          buildItemsImagePlaceHolder(
                        type: AppItemsType.ALBUM,
                      ),
                      placeholder: (context, url) => buildItemsImagePlaceHolder(
                        type: AppItemsType.ALBUM,
                      ),
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                widget.appItemType == AppItemsType.ARTIST
                                    ? BorderRadius.circular(
                                        AppValues.searchFrontPageItemsImageSize)
                                    : BorderRadius.circular(2),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder(
      {required AppItemsType type}) {
    return AppItemsImagePlaceHolder(appItemsType: type);
  }
}
