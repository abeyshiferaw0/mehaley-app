import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/data_providers/my_playlist_data_provider.dart';
import 'package:elf_play/data/models/api_response/my_playlist_page_data.dart';
import 'package:elf_play/data/models/my_playlist.dart';

class MyPLayListRepository {
  ///INIT PROVIDER FOR API CALL
  final MyPlaylistDataProvider myPLayListDataProvider;

  const MyPLayListRepository({required this.myPLayListDataProvider});

  ///POST MY PLAYLIST
  Future<MyPlaylist> postMyPlaylist(
    File playlistImage,
    String playlistName,
    String playlistDescription,
  ) async {
    MyPlaylist myPlaylist;

    Response response = await myPLayListDataProvider.postMyPlaylist(
      playlistImage,
      playlistName,
      playlistDescription,
    );

    if (response.statusCode == 200) {
      myPlaylist = MyPlaylist.fromMap(
        response.data['result'],
      );
      return myPlaylist;
    } else {
      throw "POST_FAILED";
    }
  }

  Future<MyPlaylistPageData> getMyPlaylistData(
      AppCacheStrategy appCacheStrategy) async {
    final List<MyPlaylist> myPlaylists;
    final Response response;

    response =
        await myPLayListDataProvider.getRawMyPlaylistData(appCacheStrategy);

    //PARSE CATEGORIES
    myPlaylists = (response.data['result'] as List)
        .map((myPlaylist) => MyPlaylist.fromMap(myPlaylist))
        .toList();

    MyPlaylistPageData myPlaylistPageData = MyPlaylistPageData(
      myPlaylists: myPlaylists,
      response: response,
    );

    return myPlaylistPageData;
  }

  cancelDio() {
    myPLayListDataProvider.cancel();
  }
}
