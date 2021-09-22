import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/data_providers/album_data_provider.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/album_page_data.dart';
import 'package:elf_play/data/models/song.dart';

class AlbumDataRepository {
  //INIT PROVIDER FOR API CALL
  final AlbumDataProvider albumDataProvider;

  const AlbumDataRepository({required this.albumDataProvider});

  Future<AlbumPageData> getAlbumData(
      int albumId, AppCacheStrategy appCacheStrategy) async {
    final List<Song> songs;
    final Album album;

    Response response =
        await albumDataProvider.getRawAlbumData(albumId, appCacheStrategy);

    //PARSE ALBUM
    album = Album.fromMap(response.data['album_data']);

    //PARSE SONGS IN ALBUM
    songs = (response.data['songs'] as List)
        .map((song) => Song.fromMap(song))
        .toList();

    AlbumPageData albumPageData =
        AlbumPageData(songs: songs, album: album, response: response);

    return albumPageData;
  }

  cancelDio() {
    albumDataProvider.cancel();
  }
}
