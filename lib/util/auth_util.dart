import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/app_user.dart';

class AuthUtil {
  static Future<bool> isUserLoggedIn() async {
    if (AppHiveBoxes.instance.userBox.get(AppValues.loggedInUserKey) != null &&
        AppHiveBoxes.instance.userBox.get(AppValues.userAccessTokenKey) !=
            null) {
      if (FirebaseAuth.instance.currentUser != null) {
        ///USER IS LOGGED IN
        return true;
      } else {
        ///USER IS NOT LOGGED IN
        return false;
      }
    } else {
      ///USER IS NOT LOGGED IN
      return false;
    }
  }

  static String getUserName(AppUser appUser) {
    if (appUser.userName != null) {
      return appUser.userName!;
    }
    if (appUser.userEmail != null) {
      return appUser.userEmail!;
    }
    return AppHiveBoxes.instance.userBox.get(
      AppValues.userTemporaryNameKey,
    );
  }

  static getUserColor(AppUser appUser) {
    Color color = Color(
      int.parse(
        AppHiveBoxes.instance.userBox.get(
          AppValues.userTemporaryColorKey,
        ),
      ),
    );
    return color.withOpacity(1.0);
  }

  static String generateTemporaryUserName() {
    Random rnd = new Random();
    int min = 0, max = 9;
    int r = min + rnd.nextInt(max - min);
    int r1 = min + rnd.nextInt(max - min);
    int r2 = min + rnd.nextInt(max - min);
    int r3 = min + rnd.nextInt(max - min);

    return 'User$r$r1$r2$r3';
  }

  static Color generateTemporaryUserColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)].shade800;
  }

  static HexColor getDominantColor(AppUser appUser) {
    AppUser appUser =
        AppHiveBoxes.instance.userBox.get(AppValues.loggedInUserKey);

    if (appUser.profileImageId != null) {
      return HexColor(appUser.profileImageId!.primaryColorHex);
    }

    return HexColor(
      '#${getUserColor(appUser).value.toRadixString(16)}',
    );
  }

  static String getUserId() {
    AppUser appUser =
        AppHiveBoxes.instance.userBox.get(AppValues.loggedInUserKey);
    return appUser.userId.toString();
  }
}
