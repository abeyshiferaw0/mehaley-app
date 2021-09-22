import 'package:elf_play/business_logic/blocs/category_page_bloc/category_page_bloc.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/data_providers/category_data_provider.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/category_page_top_data.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';

class CategoryDataRepository {
  //INIT PROVIDER FOR API CALL
  final CategoryDataProvider categoryDataProvider;

  const CategoryDataRepository({required this.categoryDataProvider});

  Future<CategoryPageTopData> getCategoryTopData(
      int categoryId, AppCacheStrategy appCacheStrategy) async {
    final List<Playlist> topPlaylist;
    final List<Album> topAlbum;

    var response = await categoryDataProvider.getRawCategoryTopData(
        categoryId, appCacheStrategy);

    //PARSE PLAYLISTS IN CATEGORY
    topPlaylist = (response.data['top_playlist'] as List)
        .map((playlist) => Playlist.fromMap(playlist))
        .toList();

    //PARSE ALBUMS IN CATEGORY
    topAlbum = (response.data['top_album'] as List)
        .map((album) => Album.fromMap(album))
        .toList();

    CategoryPageTopData categoryPageTopData = CategoryPageTopData(
      topAlbum: topAlbum,
      response: response,
      topPlaylist: topPlaylist,
    );

    return categoryPageTopData;
  }

  Future<List<Song>> getCategorySongData(
      int categoryId, int page, int pageSize) async {
    final List<Song> songs;

    var response = await categoryDataProvider.getRawPaginatedSongs(
        categoryId, page, pageSize);

    //PARSE SONGS IN CATEGORY
    songs = (response.data as List).map((song) => Song.fromMap(song)).toList();

    return songs;
  }

  cancelDio() {
    categoryDataProvider.cancel();
  }
}
