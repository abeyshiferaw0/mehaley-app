import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/util/api_util.dart';

class UserPlaylistDataProvider {
  late Dio dio;
  late CacheOptions cacheOptions;

  Future<Response> postUserPlaylist(
    File playlistImage,
    String playlistName,
    String playlistDescription,
    bool createWithSong,
    Song? song,
  ) async {
    dio = Dio();

    ///SEND REQUEST

    ///CHECK IF IMAGE EXISTS
    bool imageExists = playlistImage.existsSync();

    Map<String, dynamic> map = {
      'playlist_name': playlistName,
      'playlist_description': playlistDescription,
    };

    ///CHECK IF CREATE WITH SONG
    if (createWithSong) {
      map['song_id'] = song!.songId;
    }

    ///CHECK IF IMAGE IS PICKED
    if (imageExists) {
      map['playlist_image'] = await MultipartFile.fromFile(playlistImage.path,
          filename: playlistImage.path.split('/').last);
    }

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    print("FormData.fromMap(map) ${map}");

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.musicBaseUrl + "/user_create_playlist/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  Future<Response> addSongUserPlaylist(
    MyPlaylist myPlaylist,
    Song song,
  ) async {
    dio = Dio();

    ///SEND REQUEST

    Map<String, dynamic> map = {
      'song_id': song.songId,
      'playlist_id[]': myPlaylist.playlistId,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    print("FormData.fromMap(map) ${map}");

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.musicBaseUrl + "/user_add_song_playlists/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
