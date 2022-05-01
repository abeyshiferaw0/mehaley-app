import 'package:hive/hive.dart';

part 'app_payment_methods.g.dart';

@HiveType(typeId: 24)
enum AppPaymentMethods {
  @HiveField(0)
  METHOD_YENEPAY,
  @HiveField(1)
  METHOD_TELEBIRR,
  @HiveField(2)
  METHOD_TELE_CARD,
  @HiveField(3)
  METHOD_INAPP,
  @HiveField(4)
  METHOD_UNK,
}
