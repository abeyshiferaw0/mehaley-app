import 'package:dio/dio.dart';
import 'package:dio/src/cancel_token.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/data_providers/search_data_provider.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/search_page_front_data.dart';
import 'package:mehaley/data/models/api_response/search_page_result_data.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

class SearchDataRepository {
  //INIT PROVIDER FOR API CALL
  final SearchDataProvider searchDataProvider;

  const SearchDataRepository({required this.searchDataProvider});

  Future<SearchPageFrontData> getSearchFrontPageData(
      AppCacheStrategy appCacheStrategy) async {
    final List<Category> topCategories;
    final List<Song> topSongs;
    final List<Artist> topArtists;
    final List<Category> allCategories;

    var response =
        await searchDataProvider.getRawSearchFrontData(appCacheStrategy);

    //PARSE TOP CATEGORIES
    topCategories = (response.data['top_categories'] as List)
        .map((category) => Category.fromMap(category))
        .toList();

    //PARSE TOP SONGS
    topSongs = (response.data['top_music'] as List)
        .map((song) => Song.fromMap(song))
        .toList();

    //PARSE TOP ARTISTS
    topArtists = (response.data['top_artist'] as List)
        .map((artist) => Artist.fromMap(artist))
        .toList();

    //PARSE ALL CATEGORIES
    allCategories = (response.data['categories'] as List)
        .map((category) => Category.fromMap(category))
        .toList();

    SearchPageFrontData searchPageFrontData = SearchPageFrontData(
      allCategories: allCategories,
      topSongs: topSongs,
      response: response,
      topArtists: topArtists,
      topCategories: topCategories,
    );

    return searchPageFrontData;
  }

  Future<SearchPageResultData> getSearchResult(
      String key, CancelToken searchResultCancelToken) async {
    final List<dynamic> result;
    final List<Song>? topArtistSongs;
    final Artist? topArtist;

    var response =
        await searchDataProvider.getSearchResult(key, searchResultCancelToken);

    result = parseSearchResult(response.data['result'] as List);

    //PARSE POPULAR SONGS
    response.data['top_artist']['songs'] != null
        ? topArtistSongs = (response.data['top_artist']['songs'] as List)
            .map((song) => Song.fromMap(song))
            .toList()
        : topArtistSongs = null;

    response.data['top_artist']['artist'] != null
        ? topArtist = Artist.fromMap(response.data['top_artist']['artist'])
        : topArtist = null;

    return SearchPageResultData(
        topArtistData: TopArtistData(
          topArtistSongs: topArtistSongs,
          topArtist: topArtist,
        ),
        result: result);
  }

  Future<SearchPageResultData> getDedicatedSearchResult(
      String key, AppSearchItemTypes appSearchItemTypes) async {
    final List<dynamic> result;

    Response response = await searchDataProvider.getDedicatedSearchResult(
        key, appSearchItemTypes);

    print("response.data['result'] ${response.data}  ${response.realUri}");

    result = parseSearchResult(response.data['result'] as List);

    return SearchPageResultData(
      topArtistData: TopArtistData(
        topArtistSongs: null,
        topArtist: null,
      ),
      result: result,
    );
  }

  List<dynamic> parseSearchResult(List<dynamic> data) {
    List<dynamic> result = [];
    data.forEach((element) {
      if (element['item_type'] ==
          EnumToString.convertToString(AppSearchItemTypes.ARTIST)) {
        result.add(
          Artist.fromMap(element),
        );
      } else if (element['item_type'] ==
          EnumToString.convertToString(AppSearchItemTypes.PLAYLIST)) {
        result.add(
          Playlist.fromMap(element),
        );
      } else if (element['item_type'] ==
          EnumToString.convertToString(AppSearchItemTypes.SONG)) {
        result.add(
          Song.fromMap(element),
        );
      } else if (element['item_type'] ==
          EnumToString.convertToString(AppSearchItemTypes.ALBUM)) {
        result.add(
          Album.fromMap(element),
        );
      }
    });
    return result;
  }

  cancelDio() {
    searchDataProvider.cancel();
  }
}
