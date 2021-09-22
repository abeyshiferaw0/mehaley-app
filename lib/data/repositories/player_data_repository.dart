import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/data/models/song.dart';

class PlayerDataRepository {
  const PlayerDataRepository();

  void addToRecentlyPlayer(Song song) {
    ///REMOVE LAST IF MORE THAN 15
    if (AppHiveBoxes.instance.recentlyPlayedBox.values.length > 15) {
      AppHiveBoxes.instance.recentlyPlayedBox.deleteAt(0);
    }

    ///REMOVE IF ALREADY IN RECENTLY PLAYED
    if (AppHiveBoxes.instance.recentlyPlayedBox.containsKey(song.songId)) {
      AppHiveBoxes.instance.recentlyPlayedBox.delete(song.songId);
    }

    ///ADD NEW VALUE
    AppHiveBoxes.instance.recentlyPlayedBox.put(song.songId, song);
  }
}
