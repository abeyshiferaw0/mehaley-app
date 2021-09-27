import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elf_play/data/data_providers/user_playlist_data_provider.dart';
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

  cancelDio() {
    userPlaylistDataProvider.cancel();
  }
}
