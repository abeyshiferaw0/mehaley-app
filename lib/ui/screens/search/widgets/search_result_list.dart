import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/search_page_result_data.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/menu/album_menu_widget.dart';
import 'package:mehaley/ui/common/menu/artist_menu_widget.dart';
import 'package:mehaley/ui/common/menu/playlist_menu_widget.dart';
import 'package:mehaley/ui/common/menu/song_menu_widget.dart';
import 'package:mehaley/ui/screens/search/widgets/search_result_footer_button.dart';
import 'package:mehaley/ui/screens/search/widgets/search_result_item.dart';
import 'package:mehaley/ui/screens/search/widgets/search_top_artist_song_item.dart';
import 'package:mehaley/util/audio_player_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';
import 'package:sizer/sizer.dart';

class SearchResultList extends StatefulWidget {
  const SearchResultList({
    Key? key,
    required this.searchPageResultData,
    required this.searchKey,
    required this.focusNode,
  }) : super(key: key);

  final SearchPageResultData searchPageResultData;
  final String searchKey;
  final FocusNode focusNode;

  @override
  _SearchResultListState createState() => _SearchResultListState(
      searchPageResultData: searchPageResultData, searchKey: searchKey);
}

class _SearchResultListState extends State<SearchResultList> {
  _SearchResultListState(
      {required this.searchKey, required this.searchPageResultData});

  final SearchPageResultData searchPageResultData;
  final String searchKey;
  List<dynamic> resultItems = [];

  @override
  void initState() {
    resultItems.addAll(searchPageResultData.result);
    resultItems.add(SearchResultOtherItems.BLANK_SPACE);
    resultItems.add(SearchResultOtherItems.SEE_ALL_SONGS);
    resultItems.add(SearchResultOtherItems.SEE_ALL_ALBUMS);
    resultItems.add(SearchResultOtherItems.SEE_ALL_ARTISTS);
    resultItems.add(SearchResultOtherItems.SEE_ALL_PLAYLISTS);
    resultItems.add(SearchResultOtherItems.BLANK_SPACE);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildSearchResultColumnList(
          resultItems,
          searchPageResultData.topArtistData,
          searchKey,
        ),
      ),
    );
  }

  List<Widget> buildSearchResultColumnList(List<dynamic> resultItems,
      TopArtistData topArtistData, String searchKey) {
    List<Widget> widgetItems = [];

    if (topArtistData.topArtist != null &&
        topArtistData.topArtistSongs != null) {
      if (topArtistData.topArtistSongs!.isNotEmpty) {
        widgetItems.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppMargin.margin_12,
              ),
              buildSearchResultItem(
                  topArtistData.topArtist, searchKey, resultItems),
              SizedBox(
                height: AppMargin.margin_20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: AppPadding.padding_12),
                child: Text(
                  AppLocale.of().popularSongsBy(
                    artistName: L10nUtil.translateLocale(
                      topArtistData.topArtist!.artistName,
                      context,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: ColorMapper.getBlack(),
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildTopArtistSongs(
                    topArtistData.topArtistSongs!,
                    topArtistData.topArtist!,
                  ),
                ),
              ),
              SizedBox(
                height: AppMargin.margin_32,
              ),
            ],
          ),
        );
      }
    }

    resultItems.forEach((element) {
      widgetItems.add(buildSearchResultItem(element, searchKey, resultItems));
    });
    return widgetItems;
  }

  Widget buildSearchResultItem(
      dynamic resultItem, String searchKey, List<dynamic> resultItems) {
    if (resultItem is Song) {
      return SearchResultItem(
        itemKey: Key('song_${resultItem.songId}'),
        title: L10nUtil.translateLocale(resultItem.songName, context),
        subTitle:
            PagesUtilFunctions.getArtistsNames(resultItem.artistsName, context),
        imagePath: resultItem.albumArt.imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.SONG,
        item: resultItem,
        searchKey: searchKey,
        items: AudioPlayerUtil.getPlayingItems(resultItem, resultItems),
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
        focusNode: widget.focusNode,
        onMenuTap: () {
          ///SHOW MENU DIALOG
          PagesUtilFunctions.showMenuSheet(
            context: context,
            child: SongMenuWidget(
              song: resultItem,
              isForMyPlaylist: false,
              onCreateWithSongSuccess: (MyPlaylist myPlaylist) {},
              onSubscribeButtonClicked: () {
                ///GO TO SUBSCRIPTION PAGE
                Navigator.pushNamed(
                  context,
                  AppRouterPaths.subscriptionRoute,
                );
              },
              onSongBuyClicked: () {
                PurchaseUtil.songMenuBuyButtonOnClick(context, resultItem);
              },
            ),
          );
        },
      );
    } else if (resultItem is Playlist) {
      return SearchResultItem(
        itemKey: Key('playlist_${resultItem.playlistId}'),
        title: L10nUtil.translateLocale(resultItem.playlistNameText, context),
        subTitle: '',
        imagePath: resultItem.playlistImage.imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.PLAYLIST,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        focusNode: widget.focusNode,
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {
          ///SHOW MENU DIALOG
          PagesUtilFunctions.showMenuSheet(
            context: context,
            child: PlaylistMenuWidget(
              playlist: resultItem,
              onBuyButtonClicked: () {
                PurchaseUtil.playlistMenuBuyButtonOnClick(
                  context,
                  resultItem,
                  false,
                );
              },
            ),
          );
        },
      );
    } else if (resultItem is Album) {
      return SearchResultItem(
        itemKey: Key('album_${resultItem.albumId}'),
        title: L10nUtil.translateLocale(resultItem.albumTitle, context),
        subTitle:
            L10nUtil.translateLocale(resultItem.artist.artistName, context),
        imagePath: resultItem.albumImages[0].imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.ALBUM,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        focusNode: widget.focusNode,
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {
          ///SHOW MENU DIALOG
          PagesUtilFunctions.showMenuSheet(
            context: context,
            child: AlbumMenuWidget(
              album: resultItem,
              onViewArtistClicked: () {
                PagesUtilFunctions.artistItemOnClick(
                  resultItem.artist,
                  context,
                );
              },
              onBuyAlbumClicked: () {
                PurchaseUtil.albumMenuBuyButtonOnClick(
                  context,
                  resultItem,
                  false,
                );
              },
            ),
          );
        },
      );
    } else if (resultItem is Artist) {
      return SearchResultItem(
        itemKey: Key('artist_${resultItem.artistId}'),
        title: L10nUtil.translateLocale(resultItem.artistName, context),
        subTitle: '',
        imagePath: resultItem.artistImages[0].imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.ARTIST,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        focusNode: widget.focusNode,
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {
          ///SHOW MENU DIALOG
          PagesUtilFunctions.showMenuSheet(
            context: context,
            child: ArtistMenuWidget(
              artist: resultItem,
            ),
          );
        },
      );
    } else if (resultItem is SearchResultOtherItems) {
      if (resultItem == SearchResultOtherItems.SEE_ALL_PLAYLISTS) {
        return SearchResultFooterButton(
          text: AppLocale.of().seeAllPlaylists,
          isForRecentItem: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterPaths.searchResultDedicatedRoute,
              arguments: ScreenArguments(
                args: {
                  'searchKey': searchKey,
                  'appSearchItemTypes': AppSearchItemTypes.PLAYLIST
                },
              ),
            );
          },
        );
      } else if (resultItem == SearchResultOtherItems.SEE_ALL_ALBUMS) {
        return SearchResultFooterButton(
          text: AppLocale.of().seeAllAlbums,
          isForRecentItem: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterPaths.searchResultDedicatedRoute,
              arguments: ScreenArguments(
                args: {
                  'searchKey': searchKey,
                  'appSearchItemTypes': AppSearchItemTypes.ALBUM
                },
              ),
            );
          },
        );
      } else if (resultItem == SearchResultOtherItems.SEE_ALL_ARTISTS) {
        return SearchResultFooterButton(
          text: AppLocale.of().seeAllArtists,
          isForRecentItem: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterPaths.searchResultDedicatedRoute,
              arguments: ScreenArguments(
                args: {
                  'searchKey': searchKey,
                  'appSearchItemTypes': AppSearchItemTypes.ARTIST
                },
              ),
            );
          },
        );
      } else if (resultItem == SearchResultOtherItems.SEE_ALL_SONGS) {
        return SearchResultFooterButton(
          text: AppLocale.of().seeAllMezmurs,
          isForRecentItem: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterPaths.searchResultDedicatedRoute,
              arguments: ScreenArguments(
                args: {
                  'searchKey': searchKey,
                  'appSearchItemTypes': AppSearchItemTypes.SONG
                },
              ),
            );
          },
        );
      } else if (resultItem == SearchResultOtherItems.BLANK_SPACE) {
        return SizedBox(height: AppMargin.margin_28);
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }

  List<Widget> buildTopArtistSongs(List<Song> topArtistSongs, Artist artist) {
    List<Widget> widgetItems = [];
    widgetItems.add(SizedBox(
      width: AppMargin.margin_12,
    ));
    topArtistSongs.forEach(
      (element) {
        widgetItems.add(
          SearchTopArtistSongItem(
            song: element,
            width: AppValues.searchTopArtistSongsWidth,
            artist: artist,
            songs: topArtistSongs,
          ),
        );
        widgetItems.add(SizedBox(
          width: AppMargin.margin_16,
        ));
      },
    );
    return widgetItems;
  }
}
