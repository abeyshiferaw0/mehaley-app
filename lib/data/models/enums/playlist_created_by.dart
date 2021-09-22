import 'package:hive/hive.dart';

part 'playlist_created_by.g.dart';

@HiveType(typeId: 9)
enum PlaylistCreatedBy {
  @HiveField(0)
  ADMIN,
  @HiveField(1)
  USER,
  @HiveField(2)
  AUTO_GENERATED
}
