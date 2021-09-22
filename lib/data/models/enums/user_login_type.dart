import 'package:hive/hive.dart';

part 'user_login_type.g.dart';

@HiveType(typeId: 10)
enum UserLoginType {
  @HiveField(0)
  PHONE_NUMBER,
  @HiveField(1)
  GOOGLE,
  @HiveField(2)
  FACEBOOK,
  @HiveField(3)
  APPLE,
  @HiveField(4)
  NONE,
}
