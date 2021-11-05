import 'package:elf_play/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/menu/album_menu_widget.dart';
import 'package:elf_play/ui/common/menu/artist_menu_widget.dart';
import 'package:elf_play/ui/common/menu/playlist_menu_widget.dart';
import 'package:elf_play/ui/common/menu/song_menu_widget.dart';
import 'package:elf_play/ui/screens/search/widgets/search_empty_message.dart';
import 'package:elf_play/ui/screens/search/widgets/search_result_item.dart';
import 'package:elf_play/util/audio_player_util.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
      backgroundColor: AppColors.black,
      appBar: AppBar(
        centerTitle: true,
        //brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: AppColors.darkGrey,
        leading: IconButton(
          iconSize: AppIconSizes.icon_size_24,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(PhosphorIcons.caret_left),
        ),
        title: Text(
          "\"${widget.searchKey}\" in ${getItemType(widget.appSearchItemTypes)}",
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            color: AppColors.lightGrey,
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
          top: AppMargin.margin_32,
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: AppMargin.margin_28,
            crossAxisSpacing: AppMargin.margin_16,
            crossAxisCount: 2,
            childAspectRatio: (1 / 1.1),
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
      return "Mezmurs";
    } else if (appSearchItemTypes == AppSearchItemTypes.PLAYLIST) {
      return "Playlists";
    } else if (appSearchItemTypes == AppSearchItemTypes.ALBUM) {
      return "Albums";
    } else if (appSearchItemTypes == AppSearchItemTypes.ARTIST) {
      return "Artists";
    }
    return "";
  }

  Widget buildSearchedItem(
    dynamic resultItem,
    List<dynamic> resultItems,
    AppSearchItemTypes appSearchItemTypes,
  ) {
    if (appSearchItemTypes == AppSearchItemTypes.SONG) {
      resultItem as Song;
      return SearchResultItem(
        itemKey: Key("song_${resultItem.songId}"),
        title: L10nUtil.translateLocale(resultItem.songName, context),
        subTitle:
            PagesUtilFunctions.getArtistsNames(resultItem.artistsName, context),
        imagePath: resultItem.albumArt.imageSmallPath,
        appSearchItemTypes: AppSearchItemTypes.SONG,
        item: resultItem,
        searchKey: widget.searchKey,
        items: AudioPlayerUtil.getPlayingItems(resultItem, resultItems),
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {
          //SHOW MENU DIALOG
          PagesUtilFunctions.showMenuDialog(
            context: context,
            child: SongMenuWidget(
              song: resultItem,
              isForMyPlaylist: false,
              onCreateWithSongSuccess: (MyPlaylist myPlaylist) {},
            ),
          );
        },
      );
    } else if (appSearchItemTypes == AppSearchItemTypes.PLAYLIST) {
      resultItem as Playlist;
      return SearchResultItem(
        itemKey: Key("playlist_${resultItem.playlistId}"),
        title: L10nUtil.translateLocale(resultItem.playlistNameText, context),
        subTitle: "",
        imagePath: resultItem.playlistImage.imageSmallPath,
        appSearchItemTypes: AppSearchItemTypes.PLAYLIST,
        searchKey: widget.searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: true,
        onMenuTap: () {
          //SHOW MENU DIALOG
          PagesUtilFunctions.showMenuDialog(
            context: context,
            child: PlaylistMenuWidget(
              playlist: resultItem,
              title: L10nUtil.translateLocale(
                  resultItem.playlistNameText, context),
              imageUrl:
                  AppApi.baseFileUrl + resultItem.playlistImage.imageMediumPath,
              isFree: resultItem.isFree,
              price: resultItem.priceEtb,
              isDiscountAvailable: resultItem.isDiscountAvailable,
              discountPercentage: resultItem.discountPercentage,
              playlistId: resultItem.playlistId,
              isFollowed: resultItem.isFollowed!,
              isPurchased: resultItem.isBought,
            ),
          );
        },
      );
    } else if (appSearchItemTypes == AppSearchItemTypes.ALBUM) {
      resultItem as Album;
      return SearchResultItem(
        itemKey: Key("album_${resultItem.albumId}"),
        title: L10nUtil.translateLocale(resultItem.albumTitle, context),
        subTitle:
            L10nUtil.translateLocale(resultItem.artist.artistName, context),
        imagePath: resultItem.albumImages[0].imageSmallPath,
        appSearchItemTypes: AppSearchItemTypes.ALBUM,
        searchKey: widget.searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {
          //SHOW MENU DIALOG
          PagesUtilFunctions.showMenuDialog(
            context: context,
            child: AlbumMenuWidget(
              albumId: resultItem.albumId,
              album: resultItem,
              rootContext: context,
              isLiked: resultItem.isLiked,
              title: L10nUtil.translateLocale(resultItem.albumTitle, context),
              imageUrl: AppApi.baseFileUrl +
                  resultItem.albumImages[0].imageMediumPath,
              price: resultItem.priceEtb,
              isFree: resultItem.isFree,
              isDiscountAvailable: resultItem.isDiscountAvailable,
              discountPercentage: resultItem.discountPercentage,
              isBought: resultItem.isBought,
            ),
          );
        },
      );
    } else if (appSearchItemTypes == AppSearchItemTypes.ARTIST) {
      resultItem as Artist;
      return SearchResultItem(
        itemKey: Key("artist_${resultItem.artistId}"),
        title: L10nUtil.translateLocale(resultItem.artistName, context),
        subTitle: "",
        imagePath: resultItem.artistImages[0].imageSmallPath,
        appSearchItemTypes: AppSearchItemTypes.ARTIST,
        searchKey: widget.searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
        onMenuTap: () {
          //SHOW MENU DIALOG
          PagesUtilFunctions.showMenuDialog(
            context: context,
            child: ArtistMenuWidget(
              title: L10nUtil.translateLocale(resultItem.artistName, context),
              imageUrl: AppApi.baseFileUrl +
                  resultItem.artistImages[0].imageMediumPath,
              isFollowing: resultItem.isFollowed!,
              artistId: resultItem.artistId,
            ),
          );
        },
      );
    } else {
      return SizedBox();
    }
  }
}
