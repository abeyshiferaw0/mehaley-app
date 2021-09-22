import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/blocs/recent_search_bloc/recent_search_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:elf_play/ui/common/song_item/song_item_badge.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/material.dart';

class SearchResultItem extends StatefulWidget {
  const SearchResultItem({
    Key? key,
    required this.itemKey,
    required this.item,
    required this.searchKey,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.appSearchItemTypes,
    required this.items,
    required this.isRecentSearchItem,
    required this.isPlaylistDedicatedResultPage,
  }) : super(key: key);

  final Key itemKey;
  final dynamic item;
  final String title;
  final List<Song> items;
  final String searchKey;
  final String imagePath;
  final String subTitle;
  final bool isRecentSearchItem;
  final bool isPlaylistDedicatedResultPage;
  final AppSearchItemTypes appSearchItemTypes;

  @override
  _SearchResultItemState createState() => _SearchResultItemState(
        itemKey: itemKey,
        item: item,
        title: title,
        subTitle: subTitle,
        searchKey: searchKey,
        appSearchItemTypes: appSearchItemTypes,
        imagePath: imagePath,
        items: items,
        isRecentSearchItem: isRecentSearchItem,
        isPlaylistDedicatedResultPage: isPlaylistDedicatedResultPage,
      );
}

class _SearchResultItemState extends State<SearchResultItem> {
  _SearchResultItemState({
    required this.isPlaylistDedicatedResultPage,
    required this.isRecentSearchItem,
    required this.items,
    required this.searchKey,
    required this.item,
    required this.itemKey,
    required this.title,
    required this.imagePath,
    required this.subTitle,
    required this.appSearchItemTypes,
  });

  final Key itemKey;
  final dynamic item;
  final List<Song> items;
  final String title;
  final String searchKey;
  final String imagePath;
  final String subTitle;
  final bool isRecentSearchItem;
  final bool isPlaylistDedicatedResultPage;
  final AppSearchItemTypes appSearchItemTypes;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        //ADD TO RECENT SEARCHED ITEM
        BlocProvider.of<RecentSearchBloc>(context)
            .add(AddRecentSearchEvent(item: item));
        //PERFORM CLICK ACTION
        PagesUtilFunctions.searchResultItemOnClick(
            appSearchItemTypes: appSearchItemTypes,
            item: item,
            playingFrom: PlayingFrom(
                from: "Playing From Search Result \"$searchKey\"",
                title: title),
            items: items,
            context: context,
            index: 0);
      },
      child: isPlaylistDedicatedResultPage
          ? buildGridItem()
          : buildListItem(context),
    );
  }

  Container buildGridItem() {
    return Container(
      key: itemKey,
      child: Column(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                //height: AppValues.customGroupItemSize,
                width: double.infinity,
                fit: BoxFit.cover,
                height: AppValues.customGroupItemSize,
                imageUrl: AppApi.baseFileUrl + imagePath,
                placeholder: (context, url) =>
                    buildImagePlaceHolder(appSearchItemTypes),
                errorWidget: (context, url, e) =>
                    buildImagePlaceHolder(appSearchItemTypes),
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
                    AppIconWidget()
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppMargin.margin_8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_10.sp),
          ),
        ],
      ),
    );
  }

  Container buildListItem(BuildContext context) {
    return Container(
      key: itemKey,
      margin: EdgeInsets.only(
        left: AppMargin.margin_12,
        bottom: AppMargin.margin_8,
        top: AppMargin.margin_8,
      ),
      child: Row(
        children: [
          AppCard(
            radius: appSearchItemTypes == AppSearchItemTypes.ARTIST
                ? AppValues.queueSongItemSize
                : 0.0,
            child: CachedNetworkImage(
              width: AppValues.queueSongItemSize,
              height: AppValues.queueSongItemSize,
              fit: BoxFit.cover,
              imageUrl: AppApi.baseFileUrl + imagePath,
              placeholder: (context, url) =>
                  buildImagePlaceHolder(appSearchItemTypes),
              errorWidget: (context, url, e) =>
                  buildImagePlaceHolder(appSearchItemTypes),
            ),
          ),
          SizedBox(width: AppMargin.margin_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_2,
                ),
                Row(
                  children: [
                    SongItemBadge(
                      tag: appSearchItemTypes == AppSearchItemTypes.SONG
                          ? "MEZMUR"
                          : EnumToString.convertToString(appSearchItemTypes),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.txtGrey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          isRecentSearchItem
              ? AppBouncingButton(
                  onTap: () {
                    //REMOVE ITEM FORM RECENT SEARCH
                    BlocProvider.of<RecentSearchBloc>(context).add(
                      RemoveRecentSearchEvent(item: item),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.padding_8),
                    child: Icon(
                      PhosphorIcons.x_light,
                      color: AppColors.grey,
                      size: AppIconSizes.icon_size_24,
                    ),
                  ),
                )
              : AppBouncingButton(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.padding_8),
                    child: Icon(
                      PhosphorIcons.dots_three_vertical_light,
                      color: AppColors.grey,
                      size: AppIconSizes.icon_size_24,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder(
    AppSearchItemTypes appSearchItemTypes) {
  if (appSearchItemTypes == AppSearchItemTypes.SONG) {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
  if (appSearchItemTypes == AppSearchItemTypes.PLAYLIST) {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.PLAYLIST);
  }
  if (appSearchItemTypes == AppSearchItemTypes.SONG) {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
  if (appSearchItemTypes == AppSearchItemTypes.ARTIST) {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ARTIST);
  }
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}
