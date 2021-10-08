import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/data_providers/auth_provider.dart';
import 'package:elf_play/data/models/api_response/save_user_data.dart';
import 'package:elf_play/data/models/app_firebase_user.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/util/auth_util.dart';

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

    ///SAVE USER AND TOKEN
    AppHiveBoxes.instance.userBox.put(
      AppValues.loggedInUserKey,
      appUser,
    );
    AppHiveBoxes.instance.userBox.put(
      AppValues.userAccessTokenKey,
      accessToken,
    );

    ///SAVE USERS TEMP NAME AND COLOR
    AppHiveBoxes.instance.userBox.put(
      AppValues.userTemporaryNameKey,
      AuthUtil.generateTemporaryUserName(),
    );
    AppHiveBoxes.instance.userBox.put(
      AppValues.userTemporaryColorKey,
      AuthUtil.generateTemporaryUserColor().value.toString(),
    );

    return SaveUserData(
      appUser: appUser,
      accessToken: accessToken,
    );
  }

  cancelDio() {
    authProvider.cancel();
  }

  updateUser(String userName, File image, bool imageChanged) async {
    Response response =
        await authProvider.updateUser(userName, image, imageChanged);
    final AppUser appUser;

    //PARSE USER
    appUser = AppUser.fromMap(response.data['user']);

    ///SAVE USER
    AppHiveBoxes.instance.userBox.put(
      AppValues.loggedInUserKey,
      appUser,
    );

    ///SAVE USERS TEMP NAME AND COLOR
    AppHiveBoxes.instance.userBox.put(
      AppValues.userTemporaryNameKey,
      AuthUtil.generateTemporaryUserName(),
    );
    AppHiveBoxes.instance.userBox.put(
      AppValues.userTemporaryColorKey,
      AuthUtil.generateTemporaryUserColor().value.toString(),
    );
    return appUser;
  }
}
