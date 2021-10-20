import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/data_providers/lyric_data_provider.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:lyrics_parser/lyrics_parser.dart';

class LyricDataRepository {
  //INIT PROVIDER FOR API CALL
  final LyricDataProvider lyricDataProvider;

  const LyricDataRepository({required this.lyricDataProvider});

  Future<List<LyricItem>> getLyricData(
      int songId, AppCacheStrategy appCacheStrategy, currentLocale) async {
    final TextLan lyricTxt;

    var response =
        await lyricDataProvider.getRawLyricData(songId, appCacheStrategy);

    //PARSE LYRIC
    lyricTxt = TextLan.fromMap(response.data['lyric_text_id']);

    List<LyricItem> lyricList = await parseLyric(lyricTxt, currentLocale);

    return lyricList;
  }

  Future<List<LyricItem>> parseLyric(lyricTxt, currentLocale) async {
    final parser = LyricsParser(L10nUtil.translateLocale(
      lyricTxt,
      null,
      mCurrentLocale: currentLocale,
    ));
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
