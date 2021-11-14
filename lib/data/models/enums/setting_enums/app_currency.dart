import 'package:hive/hive.dart';

part 'app_currency.g.dart';

@HiveType(typeId: 25)
enum AppCurrency {
  @HiveField(0)
  ETB,
  @HiveField(1)
  USD,
}
