import 'package:hive/hive.dart';

part 'song_sync_played_from.g.dart';

@HiveType(typeId: 18)
enum SongSyncPlayedFrom {
  @HiveField(0)
  SEARCH,
  @HiveField(1)
  ARTIST_DETAIL,
  @HiveField(2)
  ALBUM_DETAIL,
  @HiveField(3)
  PLAYLIST_DETAIL,
  @HiveField(4)
  CATEGORY_DETAIL,
  @HiveField(5)
  FOR_YOU,
  @HiveField(6)
  SONG_GROUP,
  @HiveField(7)
  PLAYLIST_GROUP,
  @HiveField(8)
  ALBUM_GROUP,
  @HiveField(9)
  ARTIST_GROUP,
  @HiveField(10)
  RECENTLY_PLAYED,
  @HiveField(11)
  OFFLINE,
  @HiveField(12)
  USER_PLAYLIST,
  @HiveField(13)
  FAVORITE_SONG,
  @HiveField(14)
  PURCHASED_SONG,
  @HiveField(15)
  CART_PAGE,
  @HiveField(16)
  PROFILE_PAGE,
  @HiveField(17)
  UNK,
}
