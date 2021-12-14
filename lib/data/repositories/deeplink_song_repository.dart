import 'package:mehaley/data/data_providers/deeplink_song_data_provider.dart';
import 'package:mehaley/data/models/song.dart';

class DeeplinkSongRepository {
  //INIT PROVIDER FOR API CALL
  final DeeplinkSongDataProvider deeplinkSongDataProvider;

  const DeeplinkSongRepository({required this.deeplinkSongDataProvider});

  Future<Song> getDeepLinkSong(int songId) async {
    final Song song;

    var response = await deeplinkSongDataProvider.getDeepLinkSong(songId);

    //PARSE SONG FROM DEEPLINK
    song = Song.fromMap(response.data);

    return song;
  }

  cancelDio() {
    deeplinkSongDataProvider.cancel();
  }
}
