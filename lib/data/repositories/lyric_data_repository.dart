import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/data_providers/lyric_data_provider.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:lyrics_parser/lyrics_parser.dart';

class LyricDataRepository {
  //INIT PROVIDER FOR API CALL
  final LyricDataProvider lyricDataProvider;

  const LyricDataRepository({required this.lyricDataProvider});

  Future<List<LyricItem>> getLyricData(
      int songId, AppCacheStrategy appCacheStrategy) async {
    final int lyricId;
    final TextLan lyricTxt;

    var response =
        await lyricDataProvider.getRawLyricData(songId, appCacheStrategy);

    //PARSE LYRIC
    lyricId = response.data['lyric_id'];
    lyricTxt = TextLan.fromMap(response.data['lyric_text_id']);

    List<LyricItem> lyricList = await parseLyric(lyricTxt);

    return lyricList;
  }

  Future<List<LyricItem>> parseLyric(lyricTxt) async {
    final parser = LyricsParser(lyricTxt.textAm);
    final result = await parser.parse();
    List<LyricItem> lyricList = [];
    int i = 0;
    for (final lyric in result.lyricList) {
      if (lyric.startTimeMillisecond != null) {
        lyricList.add(
          LyricItem(
            startTimeMillisecond: lyric.startTimeMillisecond!.toDouble(),
            content: lyric.content,
            index: i,
          ),
        );
        i++;
      }
    }
    return lyricList;
  }

  cancelDio() {
    lyricDataProvider.cancel();
  }
}
