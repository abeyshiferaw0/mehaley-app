import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/auth_provider.dart';
import 'package:mehaley/data/models/api_response/save_user_data.dart';
import 'package:mehaley/data/models/app_firebase_user.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthRepository {
  //INIT PROVIDER FOR API CALL
  final AuthProvider authProvider;

  const AuthRepository({required this.authProvider});

  Future<void> setOneSignalExternalId(AppUser appUser) async {
    ///SET ONE SIGNAL EXTERNAL ID
    await OneSignal.shared.setExternalUserId(appUser.userId.toString()).then(
      (results) {
        return;
      },
    ).catchError(
      (error) {
        throw error.toString();
      },
    ).onError(
      (error, stackTrace) {
        throw error.toString();
      },
    );
  }

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

  logOutFirebase() async {
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut();
  }

  logOut() async {
    await AppHiveBoxes.instance.userBox.clear();
    await authProvider.clearDioCache();
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut();

    ///DON'T AWAIT THIS TWO BECAUSE THEY MIGHT TAKE TOO LONG FOR APP TO LOGOUT
    OneSignal.shared.removeExternalUserId();
    OneSignal.shared.disablePush(true);
  }

  Future<void> turnAllNotificationOn() async {
    ///TURN ALL NOTIFICATION ON
    await OneSignal.shared.sendTags(
      {
        EnumToString.convertToString(
            AppUserNotificationTypes.RECEIVE_ADMIN_NOTIFICATIONS): "1",
        EnumToString.convertToString(
            AppUserNotificationTypes.RECEIVE_NEW_RELEASES_NOTIFICATIONS): "1",
        EnumToString.convertToString(
            AppUserNotificationTypes.RECEIVE_LATEST_UPDATES_NOTIFICATIONS): "1",
        EnumToString.convertToString(AppUserNotificationTypes
            .RECEIVE_DAILY_CEREMONIES_NOTIFICATIONS): "1",
      },
    ).catchError(
      (error) {
        throw '${error.toString()}';
      },
    ).onError(
      (error, stackTrace) {
        throw error.toString();
      },
    ).then((value) {
      return;
    });
  }
}
