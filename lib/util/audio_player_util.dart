import 'package:audio_session/audio_session.dart';
import 'package:mehaley/data/models/song.dart';

class AudioPlayerUtil {
  static void initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  static double getCorrectProgress(double progress, double totalDuration) {
    if (progress < 0.0) {
      return 0.0;
    } else if (progress >= totalDuration) {
      return totalDuration;
    }
    return progress;
  }

  static List<Song> getPlayingItems(
      Song resultItem, List<dynamic> resultItems) {
    List<Song> playItems = [];
    playItems.add(resultItem);
    resultItems.forEach((element) {
      if (element is Song) {
        if (element.songId != resultItem.songId) {
          playItems.add(element);
        }
      }
    });
    return playItems;
  }

  // static Map<String, dynamic> toSongMap(Song song) {
  //   // ignore: unnecessary_cast
  //   return {
  //     'song_id': song.songId,
  //     'song_name_text_id': song.songName,
  //     'song_bg_video': song.songBgVideo,
  //     'lyric': song.lyric,
  //     'album_art': song.albumArt,
  //     'audio_file_id': song.audioFile,
  //     'artists_name': song.artistsName,
  //     'lyric_included': song.lyricIncluded,
  //     'price': song.price,
  //     'is_free': song.isFree,
  //     'is_only_on_elf': song.isOnlyOnElf,
  //     'performed_by': song.performedBy,
  //     'written_by_text': song.writtenByText,
  //     'produced_by': song.producedBy,
  //     'source': song.source,
  //     'released_date': song.releasedDate,
  //     'song_created_date': song.songCreatedDate,
  //     'song_updated_dated': song.songUpdatedDated,
  //   } as Map<String, dynamic>;
  // }
}
