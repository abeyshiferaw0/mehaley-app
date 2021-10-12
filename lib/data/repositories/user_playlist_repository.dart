import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/data_providers/user_playlist_data_provider.dart';
import 'package:elf_play/data/models/api_response/user_playlist_page_data.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/song.dart';

class UserPLayListRepository {
  ///INIT PROVIDER FOR API CALL
  final UserPlaylistDataProvider userPlaylistDataProvider;

  const UserPLayListRepository({required this.userPlaylistDataProvider});

  ///POST MY PLAYLIST
  Future<MyPlaylist> postUserPlaylist(
    File playlistImage,
    String playlistName,
    String playlistDescription,
    bool createWithSong,
    Song? song,
  ) async {
    MyPlaylist myPlaylist;

    Response response = await userPlaylistDataProvider.postUserPlaylist(
      playlistImage,
      playlistName,
      playlistDescription,
      createWithSong,
      song,
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

  ///UPDATE PLAYLIST
  Future<MyPlaylist> updateUserPlaylist(int playlistId, String playlistName,
      String playlistDescription, File playlistImage, bool imageRemoved) async {
    MyPlaylist myPlaylist;

    Response response = await userPlaylistDataProvider.updateUserPlaylist(
      playlistId,
      playlistName,
      playlistDescription,
      playlistImage,
      imageRemoved,
    );

    if (response.statusCode == 200) {
      myPlaylist = MyPlaylist.fromMap(
        response.data['result'],
      );
      return myPlaylist;
    } else {
      throw "UPDATE_FAILED";
    }
  }

  ///ADD SONG TOP PLAYLIST MY PLAYLIST
  Future<Response> addSongUserPlaylist(
    MyPlaylist myPlaylist,
    Song song,
  ) async {
    Response response = await userPlaylistDataProvider.addSongUserPlaylist(
      myPlaylist,
      song,
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw "POST_FAILED";
    }
  }

  Future<UserPlaylistPageData> getUserPlaylistData(
      int playlistId, AppCacheStrategy appCacheStrategy) async {
    final List<Song> songs;
    final MyPlaylist myPlaylist;

    var response = await userPlaylistDataProvider.getRawUserPlaylistData(
        playlistId, appCacheStrategy);

    //PARSE PLAYLIST
    myPlaylist = MyPlaylist.fromMap(response.data['playlist_data']);

    //PARSE SONGS IN PLAYLIST
    songs = (response.data['songs'] as List)
        .map((song) => Song.fromMap(song['song']))
        .toList();

    UserPlaylistPageData userPlaylistPageData = UserPlaylistPageData(
      songs: songs,
      response: response,
      myPlaylist: myPlaylist,
    );

    return userPlaylistPageData;
  }

  removeSongUserPlaylist(MyPlaylist myPlaylist, Song song) async {
    Response response = await userPlaylistDataProvider.removeSongUserPlaylist(
      myPlaylist,
      song,
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw "POST_FAILED";
    }
  }

  deletePlaylist(MyPlaylist myPlaylist) async {
    Response response =
        await userPlaylistDataProvider.deletePlaylist(myPlaylist);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw "DELETE_FAILED";
    }
  }

  cancelDio() {
    userPlaylistDataProvider.cancel();
  }
}
