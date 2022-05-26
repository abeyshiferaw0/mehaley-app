import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/data/models/remote_image.dart';

part 'app_user.g.dart';

@HiveType(typeId: 11)
class AppUser extends Equatable {
  @HiveField(0)
  final int userId;
  @HiveField(1)
  final String? userName;
  @HiveField(2)
  final String? userEmail;
  @HiveField(3)
  final String? phoneNumberCountryCode;
  @HiveField(4)
  final String? phoneNumber;
  @HiveField(5)
  final String? socialProfileImgUrl;
  @HiveField(6)
  final String authLoginId;
  @HiveField(7)
  final UserLoginType loginType;
  @HiveField(8)
  final RemoteImage? profileImageId;
  @HiveField(9)
  final DateTime dateCreated;
  @HiveField(10)
  final DateTime dateModified;
  @HiveField(11, defaultValue: null)
  final bool? isPhoneAuthenticated;

  @override
  List<Object?> get props => [
        userId,
        userName,
        userEmail,
        phoneNumberCountryCode,
        phoneNumber,
        isPhoneAuthenticated,
        socialProfileImgUrl,
        authLoginId,
        loginType,
        profileImageId,
        dateCreated,
        dateModified,
      ];

  AppUser({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.phoneNumberCountryCode,
    required this.phoneNumber,
    required this.isPhoneAuthenticated,
    required this.socialProfileImgUrl,
    required this.authLoginId,
    required this.loginType,
    required this.profileImageId,
    required this.dateCreated,
    required this.dateModified,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return new AppUser(
      userId: map['user_id'] as int,
      userName: map['user_name'] as String?,
      userEmail: map['user_email'] as String?,
      phoneNumberCountryCode: map['phone_number_country_code'] as String?,
      isPhoneAuthenticated: map['is_phone_authenticated'] == 1 ? true : false,
      phoneNumber: map['phone_number'] as String?,
      socialProfileImgUrl: map['social_profile_img_url'] as String?,
      authLoginId: map['auth_login_id'] as String,
      loginType:
          EnumToString.fromString(UserLoginType.values, map['login_type'])
              as UserLoginType,
      profileImageId: map['profile_image_id'] != null
          ? RemoteImage.fromMap(map['profile_image_id'])
          : null,
      dateCreated: DateTime.parse(map['date_created']),
      dateModified: DateTime.parse(map['date_modified']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'user_id': this.userId,
      'user_name': this.userName,
      'user_email': this.userEmail,
      'phone_number_country_code': this.phoneNumberCountryCode,
      'phone_number': this.phoneNumber,
      'is_phone_authenticated': this.isPhoneAuthenticated,
      'social_profile_img_url': this.socialProfileImgUrl,
      'auth_login_id': this.authLoginId,
      'login_type': this.loginType,
      'profile_image_id': this.profileImageId,
      'date_created': this.dateCreated,
      'date_modified': this.dateModified,
    } as Map<String, dynamic>;
  }
}
