import 'package:dio/dio.dart';
import 'package:elf_play/data/data_providers/auth_provider.dart';
import 'package:elf_play/data/models/api_response/save_user_data.dart';
import 'package:elf_play/data/models/app_firebase_user.dart';
import 'package:elf_play/data/models/app_user.dart';

class AuthRepository {
  //INIT PROVIDER FOR API CALL
  final AuthProvider authProvider;

  const AuthRepository({required this.authProvider});

  Future<SaveUserData> saveUser(AppFireBaseUser appFireBaseUser) async {
    Response response = await authProvider.saveUser(appFireBaseUser);
    final AppUser appUser;
    final String accessToken;

    //PARSE USER
    appUser = AppUser.fromMap(response.data['user']);

    //PARSE ACCESS TOKEN
    accessToken = response.data['access_token'];

    return SaveUserData(
      appUser: appUser,
      accessToken: accessToken,
    );
  }

  cancelDio() {
    authProvider.cancel();
  }
}
