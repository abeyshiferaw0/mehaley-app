import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/app_user.dart';

class SaveUserData extends Equatable {
  final AppUser appUser;
  final String accessToken;

  const SaveUserData({
    required this.appUser,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
        appUser,
        accessToken,
      ];
}
