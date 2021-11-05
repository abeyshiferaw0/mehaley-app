import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/data_providers/playlist_data_provider.dart';
import 'package:elf_play/data/models/api_response/playlist_page_data.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';

class PlaylistDataRepository {
  //INIT PROVIDER FOR API CALL
  final PlaylistDataProvider playlistDataProvider;

  const PlaylistDataRepository({required this.playlistDataProvider});

  Future<PlaylistPageData> getPlaylistData(
      int playlistId, AppCacheStrategy appCacheStrategy) async {
    final List<Song> songs;
    final int numberOfFollowers;
    final Playlist playlist;

    var response = await playlistDataProvider.getRawPlaylistData(
        playlistId, appCacheStrategy);

    //PARSE PLAYLIST
    playlist = Playlist.fromMap(response.data['playlist_data']);

    //PARSE NUMBER OF FOLLOWERS
    numberOfFollowers = response.data['number_of_followers'] as int;

    //PARSE SONGS IN PLAYLIST
    songs = (response.data['songs'] as List)
        .map((song) => Song.fromMap(song))
        .toList();

    PlaylistPageData playlistPageData = PlaylistPageData(
      songs: songs,
      response: response,
      playlist: playlist,
      numberOfFollowers: numberOfFollowers,
    );

    return playlistPageData;
  }

  cancelDio() {
    playlistDataProvider.cancel();
  }
}
