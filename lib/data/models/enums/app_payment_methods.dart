import 'package:hive/hive.dart';

part 'app_payment_methods.g.dart';

@HiveType(typeId: 24)
enum AppPaymentMethods {
  @HiveField(0)
  METHOD_AMOLE,
  @HiveField(1)
  METHOD_CBE_BIRR,
  @HiveField(2)
  METHOD_HELLO_CASH,
  @HiveField(3)
  METHOD_MBIRR,
  @HiveField(4)
  METHOD_VISA,
  @HiveField(5)
  METHOD_MASTERCARD,
  @HiveField(6)
  METHOD_UNK,
}
