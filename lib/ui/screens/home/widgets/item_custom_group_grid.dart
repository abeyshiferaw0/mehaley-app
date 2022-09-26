import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/app_image_tint.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/screens/home/widgets/group_song_item_play_icon.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ItemCustomGroupGrid extends StatelessWidget {
  final dynamic item;
  final GroupType groupType;
  final VoidCallback onTap;

  ItemCustomGroupGrid({
    required this.item,
    required this.groupType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      //behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: groupType == GroupType.ARTIST
            ? CrossAxisAlignment.center
            :  CrossAxisAlignment.start,
        children: [

          Expanded(
            child: CachedNetworkImage(
              //height: AppValues.customGroupItemSize,
              width: double.infinity,
              fit: BoxFit.cover,
              //height: AppValues.customGroupItemSize,
              imageUrl: PagesUtilFunctions.getGroupImageUrl(groupType, item),
              placeholder: (context, url) => buildItemsImagePlaceHolder(),
              errorWidget: (context, url, error) =>
                  buildItemsImagePlaceHolder(),
              imageBuilder: (context, imageProvider) => Stack(
                children: [

                  ///USE CIRCLE AVATAR IF GROUP TYPE IS ARTISTS
                  groupType != GroupType.ARTIST
                      ?   buildOtherGroupsImage(imageProvider)
                      : buildArtistImage(imageProvider) ,




                  groupType != GroupType.ARTIST
                      ? AppIconWidget()
                      : SizedBox(),

                  ///TINT IMAGES
                  // AppImageTint(),

                  ///PLAY ICON IF SONG ITEM
                  GroupSongItemPlayIcon(
                    groupType: groupType,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: AppMargin.margin_8),
          // Text(
          //   PagesUtilFunctions.getGroupItemTitle(groupType, item, context),
          //   textAlign: TextAlign.start,
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          //   style: TextStyle(
          //     color: ColorMapper.getBlack(),
          //     fontWeight: FontWeight.w400,
          //     fontSize: AppFontSizes.font_size_10.sp,
          //   ),
          // ),
          Text(
            PagesUtilFunctions.getGroupItemMainTitle(groupType, item, context),
            maxLines: 1,
            textAlign: groupType == GroupType.ARTIST
                ? TextAlign.center
                : TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorMapper.getBlack(),
              fontWeight: FontWeight.w500,
              fontSize: AppFontSizes.font_size_10.sp,
            ),
          ),

          Text(
            PagesUtilFunctions.getGroupItemSubTitle(groupType, item, context),
            maxLines: 1,
            textAlign: groupType == GroupType.ARTIST
                ? TextAlign.center
                : TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorMapper.getTxtGrey(),
              fontWeight: FontWeight.w400,
              fontSize: AppFontSizes.font_size_8.sp,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PagesUtilFunctions.getGroupItemType(groupType),
              PagesUtilFunctions.getGroupItemPrice(groupType, item),
            ],
          ),
        ],
      ),
    );
  }

  ClipRRect buildOtherGroupsImage(ImageProvider<Object> imageProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Align buildArtistImage(ImageProvider<Object> imageProvider) {


    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: AppValues.customGroupItemSize,
        child: CircleAvatar(
          radius: AppValues.customGroupItemSize,
          backgroundImage: imageProvider,
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(
        appItemsType:
            PagesUtilFunctions.getGroupItemImagePlaceHolderType(groupType));
  }
}
