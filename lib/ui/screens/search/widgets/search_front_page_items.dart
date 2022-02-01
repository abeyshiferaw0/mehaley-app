import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/color_util.dart';
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
      child: AppCard(
        radius: 6.0,
        child: Stack(
          children: [
            buildBackgroundContainer(),
            AppCard(
              radius: 4.0,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.imageUrl,
                placeholder: (context, url) => buildBackgroundContainer(),
                errorWidget: (context, url, e) => buildBackgroundContainer(),
                imageBuilder: (context, imageProvider) => Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      color: ColorUtil.darken(widget.dominantColor, 0.5)
                          .withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.padding_8),
                child: Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildBackgroundContainer() {
    return Container(
      decoration: BoxDecoration(
        color: widget.dominantColor,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder(
      {required AppItemsType type}) {
    return AppItemsImagePlaceHolder(appItemsType: type);
  }
}
