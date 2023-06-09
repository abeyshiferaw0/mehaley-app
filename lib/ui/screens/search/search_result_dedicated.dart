import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/menu/album_menu_widget.dart';
import 'package:mehaley/ui/common/menu/artist_menu_widget.dart';
import 'package:mehaley/ui/common/menu/playlist_menu_widget.dart';
import 'package:mehaley/ui/common/menu/song_menu_widget.dart';
import 'package:mehaley/ui/screens/search/widgets/search_empty_message.dart';
import 'package:mehaley/ui/screens/search/widgets/search_result_item.dart';
import 'package:mehaley/util/audio_player_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';
import 'package:sizer/sizer.dart';

class SearchResultDedicated extends StatefulWidget {
  const SearchResultDedicated(
      {Key? key, required this.searchKey, required this.appSearchItemTypes})
      : super(key: key);

  final String searchKey;
  final AppSearchItemTypes appSearchItemTypes;

  @override
  _SearchResultDedicatedState createState() => _SearchResultDedicatedState();
}

class _SearchResultDedicatedState extends State<SearchResultDedicated> {
  @override
  void initState() {
    //LOAD SEARCHED ITEMS
    BlocProvider.of<SearchResultBloc>(context).add(
      LoadSearchResultDedicatedEvent(
        appSearchItemTypes: widget.appSearchItemTypes,
        key: widget.searchKey,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorMapper.getPagesBgColor(),
      appBar: AppBar(
        centerTitle: true,
        //brightness: Brightness.dark,
        systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
        backgroundColor: ColorMapper.getWhite(),
        shadowColor: AppColors.transparent,
        leading: IconButton(
          iconSize: AppIconSizes.icon_size_24,
          color: ColorMapper.getBlack(),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(FlutterRemix.arrow_left_line),
        ),
        title: Text(
          AppLocale.of().searchDedicatedTitle(
            searchKey: widget.searchKey,
            appItemType: getItemType(widget.appSearchItemTypes),
          ),
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            color: ColorMapper.getDarkGrey(),
          ),
        ),
      ),
      body: BlocBuilder<SearchResultBloc, SearchResultState>(
        builder: (context, state) {
          if (state is SearchResultPageDedicatedLoadedState) {
            if (state.searchPageResultData.result.length > 0) {
              return buildSearchResultDedicatedList(state);
            } else {
              return SearchEmptyMessage(
                searchKey: widget.searchKey,
              );
            }
          }
          if (state is SearchResultPageDedicatedLoadingState) {
            return AppLoading(size: AppValues.loadingWidgetSize);
          }
          if (state is SearchResultPageDedicatedLoadingErrorState) {
            return AppError(
              bgWidget: AppLoading(size: AppValues.loadingWidgetSize),
              onRetry: () {
                //LOAD SEARCHED ITEMS
                BlocProvider.of<SearchResultBloc>(context).add(
                  LoadSearchResultDedicatedEvent(
                    appSearchItemTypes: widget.appSearchItemTypes,
                    key: widget.searchKey,
                  ),
                );
              },
            );
          }
          return AppLoading(size: AppValues.loadingWidgetSize);
        },
      ),
    );
  }

  Widget buildSearchResultDedicatedList(
      SearchResultPageDedicatedLoadedState state) {
    if (state.appSearchItemTypes == AppSearchItemTypes.PLAYLIST) {
      return Padding(
        padding: const EdgeInsets.only(
          left: AppMargin.margin_16,
          right: AppMargin.margin_16,
          top: AppMargin.margin_16,
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: AppMargin.margin_16,
            crossAxisSpacing: AppMargin.margin_16,
            crossAxisCount: 2,
            childAspectRatio: (1 / 1.2),
          ),
          physics: BouncingScrollPhysics(),
          itemCount: state.searchPageResultData.result.length,
          itemBuilder: (context, index) {
            return buildSearchedItem(
              state.searchPageResultData.result.elementAt(index),
              state.searchPageResultData.result,
              state.appSearchItemTypes,
            );
          },
        ),
      );
    } else {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: state.searchPageResultData.result.length,
        itemBuilder: (context, index) {
          return buildSearchedItem(
            state.searchPageResultData.result.elementAt(index),
            state.searchPageResultData.result,
            state.appSearchItemTypes,
          );
        },
      );
    }
  }

  String getItemType(AppSearchItemTypes appSearchItemTypes) {
    if (appSearchItemTypes == AppSearchItemTypes.SONG) {
      return AppLocale.of().mezmurs;
    } else if (appSearchItemTypes == AppSearchItemTypes.PLAYLIST) {
      return AppLocale.of().playlists;
    } else if (appSearchItemTypes == AppSearchItemTypes.ALBUM) {
      return AppLocale.of().albums;
    } else if (appSearchItemTypes == AppSearchItemTypes.ARTIST) {
      return AppLocale.of().artists;
    }
    return '';
  }

  Widget buildSearchedItem(
    dynamic resultItem,
    List<dynamic> resultItems,
    AppSearchItemTypes appSearchItemTypes,
  ) {
    if (appSearchItemTypes == AppSearchItemTypes.SONG) {
      resultItem as Song;
      return SearchResultItem(
        itemKey: Key('song_${resultItem.songId}'),
        title: L10nUtil.translateLocale(resultItem.songName, context),
        subTitle:
            PagesUtilFunctions.getArtistsNames(resultItem.artistsName, context),
        imagePath: resultItem.albumArt.imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.SONG,
        item: resultItem,
        searchKey: widget.searchKey,
        items: AudioPlayerUtil.getPlayingItems(resultItem, resultItems),
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
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
    } else if (appSearchItemTypes == AppSearchItemTypes.PLAYLIST) {
      resultItem as Playlist;
      return SearchResultItem(
        itemKey: Key('playlist_${resultItem.playlistId}'),
        title: L10nUtil.translateLocale(resultItem.playlistNameText, context),
        subTitle: '',
        imagePath: resultItem.playlistImage.imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.PLAYLIST,
        searchKey: widget.searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: true,
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
    } else if (appSearchItemTypes == AppSearchItemTypes.ALBUM) {
      resultItem as Album;
      return SearchResultItem(
        itemKey: Key('album_${resultItem.albumId}'),
        title: L10nUtil.translateLocale(resultItem.albumTitle, context),
        subTitle:
            L10nUtil.translateLocale(resultItem.artist.artistName, context),
        imagePath: resultItem.albumImages[0].imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.ALBUM,
        searchKey: widget.searchKey,
        item: resultItem,
        items: [],
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
    } else if (appSearchItemTypes == AppSearchItemTypes.ARTIST) {
      resultItem as Artist;
      return SearchResultItem(
        itemKey: Key('artist_${resultItem.artistId}'),
        title: L10nUtil.translateLocale(resultItem.artistName, context),
        subTitle: '',
        imagePath: resultItem.artistImages[0].imageMediumPath,
        appSearchItemTypes: AppSearchItemTypes.ARTIST,
        searchKey: widget.searchKey,
        item: resultItem,
        items: [],
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
    } else {
      return SizedBox();
    }
  }
}
