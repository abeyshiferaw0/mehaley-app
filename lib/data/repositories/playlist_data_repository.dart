import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/data_providers/home_data_provider.dart';
import 'package:elf_play/data/data_providers/playlist_data_provider.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/home_page_data.dart';
import 'package:elf_play/data/models/api_response/playlist_page_data.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/group.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';

class PlaylistDataRepository {
  //INIT PROVIDER FOR API CALL
  final PlaylistDataProvider playlistDataProvider;

  const PlaylistDataRepository({required this.playlistDataProvider});

  Future<PlaylistPageData> getPlaylistData(
      int playlistId, AppCacheStrategy appCacheStrategy) async {
    final List<Song> songs;
    final Playlist playlist;

    var response = await playlistDataProvider.getRawPlaylistData(
        playlistId, appCacheStrategy);

    //PARSE PLAYLIST
    playlist = Playlist.fromMap(response.data['playlist_data']);

    //PARSE SONGS IN PLAYLIST
    songs = (response.data['songs'] as List)
        .map((song) => Song.fromMap(song))
        .toList();

    PlaylistPageData playlistPageData = PlaylistPageData(
      songs: songs,
      response: response,
      playlist: playlist,
    );

    return playlistPageData;
  }

  cancelDio() {
    playlistDataProvider.cancel();
  }
}
