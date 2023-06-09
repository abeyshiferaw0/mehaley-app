import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/recent_search_bloc/recent_search_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/screens/search/widgets/search_result_item.dart';
import 'package:mehaley/util/audio_player_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class SearchRecentOrMessage extends StatefulWidget {
  const SearchRecentOrMessage({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchRecentOrMessage> createState() => _SearchRecentOrMessageState();
}

class _SearchRecentOrMessageState extends State<SearchRecentOrMessage> {
  @override
  void initState() {
    BlocProvider.of<RecentSearchBloc>(context).add(LoadRecentSearchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentSearchBloc, RecentSearchState>(
      builder: (context, state) {
        if (state is RecentChangedState) {
          if (state.items.isEmpty) {
            return buildSearchElfMessage(context);
          } else {
            return buildRecentItems(state.items, context);
          }
        } else {
          return buildSearchElfMessage(context);
        }
      },
    );
  }

  SingleChildScrollView buildRecentItems(
      List<dynamic> recentItems, BuildContext context) {
    //ADD CLEAR ALL RECENT BUTTON
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getRecentItems(recentItems, context),
      ),
    );
  }

  Container buildSearchElfMessage(context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                AppLocale.of().searchElfFor,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorMapper.getBlack(),
                  fontWeight: FontWeight.w600,
                  fontSize: AppFontSizes.font_size_14.sp,
                ),
              ),
            ),
            SizedBox(
              height: AppMargin.margin_4,
            ),
            Center(
              child: Text(
                AppLocale.of().searchHint2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorMapper.getBlack(),
                  fontSize: AppFontSizes.font_size_10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getRecentItems(List<dynamic> recentItems, BuildContext context) {
    List<Widget> widgetItems = [];
    widgetItems.add(
      Container(
        padding: const EdgeInsets.only(left: AppPadding.padding_12),
        margin: const EdgeInsets.only(bottom: AppMargin.margin_16),
        child: Text(
          AppLocale.of().recentSearches,
          style: TextStyle(
            color: ColorMapper.getBlack(),
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    recentItems.forEach(
      (element) {
        widgetItems.add(
          buildRecentSearchItems(element, '', recentItems, context),
        );
      },
    );

    widgetItems.add(
      AppBouncingButton(
        onTap: () {
          //REMOVE ALL RECENT SEARCHES
          BlocProvider.of<RecentSearchBloc>(context).add(
            RemoveAllRecentSearchEvent(),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: AppMargin.margin_16,
          ),
          padding: const EdgeInsets.only(
            left: AppPadding.padding_12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().clearRecentSearches,
                style: TextStyle(
                  color: ColorMapper.getTxtGrey(),
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: AppMargin.margin_8,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  FlutterRemix.close_line,
                  color: ColorMapper.getDarkGrey(),
                  size: AppIconSizes.icon_size_12,
                ),
              )
            ],
          ),
        ),
      ),
    );
    return widgetItems;
  }

  Widget buildRecentSearchItems(dynamic resultItem, String searchKey,
      List<dynamic> resultItems, BuildContext context) {
    if (resultItem is Song) {
      return SearchResultItem(
        key: Key('song_${resultItem.songId}'),
        itemKey: Key('song_${resultItem.songId}'),
        title: L10nUtil.translateLocale(resultItem.songName, context),
        subTitle:
            PagesUtilFunctions.getArtistsNames(resultItem.artistsName, context),
        imagePath: resultItem.albumArt.imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.SONG,
        item: resultItem,
        searchKey: searchKey,
        items: AudioPlayerUtil.getPlayingItems(resultItem, resultItems),
        isRecentSearchItem: true,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {},
      );
    } else if (resultItem is Playlist) {
      return SearchResultItem(
        key: Key('playlist_${resultItem.playlistId}'),
        itemKey: Key('playlist_${resultItem.playlistId}'),
        title: L10nUtil.translateLocale(resultItem.playlistNameText, context),
        subTitle: '',
        imagePath: resultItem.playlistImage.imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.PLAYLIST,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: true,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {},
      );
    } else if (resultItem is Album) {
      return SearchResultItem(
        key: Key('album_${resultItem.albumId}'),
        itemKey: Key('album_${resultItem.albumId}'),
        title: L10nUtil.translateLocale(resultItem.albumTitle, context),
        subTitle:
            L10nUtil.translateLocale(resultItem.artist.artistName, context),
        imagePath: resultItem.albumImages[0].imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.ALBUM,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: true,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {},
      );
    } else if (resultItem is Artist) {
      return SearchResultItem(
        key: Key('artist_${resultItem.artistId}'),
        itemKey: Key('artist_${resultItem.artistId}'),
        title: L10nUtil.translateLocale(resultItem.artistName, context),
        subTitle: '',
        imagePath: resultItem.artistImages[0].imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.ARTIST,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: true,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {},
      );
    } else {
      return SizedBox();
    }
  }
}
