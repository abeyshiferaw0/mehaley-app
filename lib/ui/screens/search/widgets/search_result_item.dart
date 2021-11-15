import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/recent_search_bloc/recent_search_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/song_item/song_item_badge.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

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
    required this.onMenuTap,
    this.focusNode,
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
  final VoidCallback onMenuTap;
  final FocusNode? focusNode;

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
        onMenuTap: onMenuTap,
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
    required this.onMenuTap,
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
  final VoidCallback onMenuTap;

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
            from: AppLocale.of().playingFromSearchResult(searchKey: searchKey),
            title: title,
            songSyncPlayedFrom: SongSyncPlayedFrom.SEARCH,
            songSyncPlayedFromId: -1,
          ),
          items: items,
          context: context,
          index: 0,
        );
        if (widget.focusNode != null) {
          widget.focusNode!.unfocus();
        }
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
                imageUrl: AppApi.baseUrl + imagePath,
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
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w600,
              fontSize: AppFontSizes.font_size_10.sp,
            ),
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
              imageUrl: AppApi.baseUrl + imagePath,
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
                    color: AppColors.darkGrey,
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
                          ? AppLocale.of().mezmurs.toUpperCase()
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
                  onTap: onMenuTap,
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
