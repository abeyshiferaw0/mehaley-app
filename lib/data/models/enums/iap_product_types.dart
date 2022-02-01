import 'package:hive/hive.dart';

part 'iap_product_types.g.dart';

@HiveType(typeId: 15)
enum IapProductTypes {
  @HiveField(0)
  SONG,
  @HiveField(1)
  ALBUM,
  @HiveField(2)
  PLAYLIST,
}
