import 'package:elf_play/data/models/enums/user_login_type.dart';
import 'package:equatable/equatable.dart';

class AppFireBaseUser extends Equatable {
  final String? userName;
  final String? email;
  final String? phoneNumberCountryCode;
  final String? phoneNumber;
  final String? socialProfileImgUrl;
  final String authLoginId;
  final UserLoginType loginType;

  AppFireBaseUser({
    required this.userName,
    required this.email,
    required this.phoneNumberCountryCode,
    required this.phoneNumber,
    required this.socialProfileImgUrl,
    required this.authLoginId,
    required this.loginType,
  });

  @override
  List<Object?> get props => [
        userName,
        email,
        phoneNumberCountryCode,
        phoneNumber,
        socialProfileImgUrl,
        authLoginId,
        loginType,
      ];
}
