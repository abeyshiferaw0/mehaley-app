import 'package:dio/dio.dart';
import 'package:dio/src/cancel_token.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/data_providers/search_data_provider.dart';
import 'package:mehaley/data/data_providers/song_menu_data_provider.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/search_page_front_data.dart';
import 'package:mehaley/data/models/api_response/search_page_result_data.dart';
import 'package:mehaley/data/models/api_response/song_menu_left_over_data_data.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

class SongMenuRepository {
  //INIT PROVIDER FOR API CALL
  final SongMenuDataProvider songMenuDataProvider;

  const SongMenuRepository({required this.songMenuDataProvider});

  Future<SongMenuLeftOverData> getSongLeftOverData(int songId) async {
    final List<Category> songCategories;
    final List<Album> songAlbums;
    final List<Artist> songArtists;

    var response = await songMenuDataProvider.getSongLeftOverData(songId);

    //PARSE SONG MENU ARTISTS
    songArtists = (response.data['artists'] as List)
        .map((artist) => Artist.fromMap(artist))
        .toList();

    //PARSE SONG MENU ALBUMS
    songAlbums = (response.data['albums'] as List)
        .map((album) => Album.fromMap(album))
        .toList();

    //PARSE SONG MENU CATEGORIES
    songCategories = (response.data['categories'] as List)
        .map((category) => Category.fromMap(category))
        .toList();

    SongMenuLeftOverData songMenuLeftOverData = SongMenuLeftOverData(
      songCategories: songCategories,
      songAlbums: songAlbums,
      songArtists: songArtists,
    );

    return songMenuLeftOverData;
  }

  cancelDio() {
    songMenuDataProvider.cancel();
  }
}
