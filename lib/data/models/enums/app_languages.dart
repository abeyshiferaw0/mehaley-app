import 'package:hive/hive.dart';

part 'app_languages.g.dart';

@HiveType(typeId: 26)
enum AppLanguage {
  @HiveField(0)
  ENGLISH,
  @HiveField(1)
  AMHARIC,
  @HiveField(2)
  OROMIFA,
  @HiveField(3)
  TIGRINYA,
}
