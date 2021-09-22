import 'package:elf_play/business_logic/cubits/search_page_dominant_color_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/util/audio_player_util.dart';
import 'package:sizer/sizer.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/search_page_result_data.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/screens/search/widgets/search_header_gradient.dart';
import 'package:elf_play/ui/screens/search/widgets/search_result_footer_button.dart';
import 'package:elf_play/ui/screens/search/widgets/search_result_item.dart';
import 'package:elf_play/ui/screens/search/widgets/search_top_artist_song_item.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultList extends StatefulWidget {
  const SearchResultList(
      {Key? key, required this.searchPageResultData, required this.searchKey})
      : super(key: key);

  final SearchPageResultData searchPageResultData;
  final String searchKey;

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
    //GET SCREEN HEIGHT
    double screenHeight = ScreenUtil(context: context).getScreenHeight();

    return Stack(
      children: [
        BlocBuilder<SearchPageDominantColorCubit, Color>(
          builder: (context, state) {
            return SearchHeaderGradient(
              height: screenHeight - (screenHeight * 0.3),
              color: state,
            );
          },
        ),
        SafeArea(
          child: Container(
            margin: const EdgeInsets.only(
                top: AppValues.searchBarHeight + AppMargin.margin_8),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildSearchResultColumnList(
                    resultItems, searchPageResultData.topArtistData, searchKey),
              ),
            ),
          ),
        ),
      ],
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
                  "Popular mezmur's by ${topArtistData.topArtist!.artistName.textAm}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.white,
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
        itemKey: Key("song_${resultItem.songId}"),
        title: resultItem.songName.textAm,
        subTitle: PagesUtilFunctions.getArtistsNames(resultItem.artistsName),
        imagePath: resultItem.albumArt.imageSmallPath,
        appSearchItemTypes: AppSearchItemTypes.SONG,
        item: resultItem,
        searchKey: searchKey,
        items: AudioPlayerUtil.getPlayingItems(resultItem, resultItems),
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
      );
    } else if (resultItem is Playlist) {
      return SearchResultItem(
        itemKey: Key("playlist_${resultItem.playlistId}"),
        title: resultItem.playlistNameText.textAm,
        subTitle: "",
        imagePath: resultItem.playlistImage.imageSmallPath,
        appSearchItemTypes: AppSearchItemTypes.PLAYLIST,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
      );
    } else if (resultItem is Album) {
      return SearchResultItem(
        itemKey: Key("album_${resultItem.albumId}"),
        title: resultItem.albumTitle.textAm,
        subTitle: resultItem.artist.artistName.textAm,
        imagePath: resultItem.albumImages[0].imageSmallPath,
        appSearchItemTypes: AppSearchItemTypes.ALBUM,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
      );
    } else if (resultItem is Artist) {
      return SearchResultItem(
        itemKey: Key("artist_${resultItem.artistId}"),
        title: resultItem.artistName.textAm,
        subTitle: "",
        imagePath: resultItem.artistImages[0].imageSmallPath,
        appSearchItemTypes: AppSearchItemTypes.ARTIST,
        searchKey: searchKey,
        item: resultItem,
        items: [],
        isRecentSearchItem: false,
        isPlaylistDedicatedResultPage: false,
      );
    } else if (resultItem is SearchResultOtherItems) {
      if (resultItem == SearchResultOtherItems.SEE_ALL_PLAYLISTS) {
        return SearchResultFooterButton(
          text: "see all playlists",
          isForRecentItem: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterPaths.searchResultDedicatedRoute,
              arguments: ScreenArguments(
                args: {
                  "searchKey": searchKey,
                  "appSearchItemTypes": AppSearchItemTypes.PLAYLIST
                },
              ),
            );
          },
        );
      } else if (resultItem == SearchResultOtherItems.SEE_ALL_ALBUMS) {
        return SearchResultFooterButton(
          text: "see all albums",
          isForRecentItem: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterPaths.searchResultDedicatedRoute,
              arguments: ScreenArguments(
                args: {
                  "searchKey": searchKey,
                  "appSearchItemTypes": AppSearchItemTypes.ALBUM
                },
              ),
            );
          },
        );
      } else if (resultItem == SearchResultOtherItems.SEE_ALL_ARTISTS) {
        return SearchResultFooterButton(
          text: "see all artists",
          isForRecentItem: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterPaths.searchResultDedicatedRoute,
              arguments: ScreenArguments(
                args: {
                  "searchKey": searchKey,
                  "appSearchItemTypes": AppSearchItemTypes.ARTIST
                },
              ),
            );
          },
        );
      } else if (resultItem == SearchResultOtherItems.SEE_ALL_SONGS) {
        return SearchResultFooterButton(
          text: "see all mezmurs",
          isForRecentItem: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterPaths.searchResultDedicatedRoute,
              arguments: ScreenArguments(
                args: {
                  "searchKey": searchKey,
                  "appSearchItemTypes": AppSearchItemTypes.SONG
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
