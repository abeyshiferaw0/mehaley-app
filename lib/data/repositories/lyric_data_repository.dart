import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/data_providers/album_data_provider.dart';
import 'package:elf_play/data/data_providers/home_data_provider.dart';
import 'package:elf_play/data/data_providers/lyric_data_provider.dart';
import 'package:elf_play/data/data_providers/playlist_data_provider.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/album_page_data.dart';
import 'package:elf_play/data/models/api_response/home_page_data.dart';
import 'package:elf_play/data/models/api_response/playlist_page_data.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/group.dart';
import 'package:elf_play/data/models/lyric.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/text_lan.dart';

class LyricDataRepository {
  //INIT PROVIDER FOR API CALL
  final LyricDataProvider lyricDataProvider;

  const LyricDataRepository({required this.lyricDataProvider});

  Future<Lyric> getLyricData(
      int songId, AppCacheStrategy appCacheStrategy) async {
    final int lyricId;
    final TextLan lyricTxt;

    var response =
        await lyricDataProvider.getRawLyricData(songId, appCacheStrategy);

    //PARSE LYRIC
    lyricId = response.data['lyric_id'];
    lyricTxt = TextLan.fromMap(response.data['lyric_text_id']);

    print("lyricTxtlyricTxt $songId ${response.data['lyric_text_id']}");

    Lyric lyric = Lyric(lyricId: lyricId, lyric: lyricTxt);

    return lyric;
  }

  cancelDio() {
    lyricDataProvider.cancel();
  }
}
