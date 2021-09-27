import 'dart:math';

import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  static String getUserName() {
    Random rnd = new Random();
    AppUser appUser =
        AppHiveBoxes.instance.userBox.get(AppValues.loggedInUserKey);
    if (appUser.userName != null) {
      return appUser.userName!;
    }
    if (appUser.userEmail != null) {
      return appUser.userEmail!;
    }

    int min = 0, max = 9;
    int r = min + rnd.nextInt(max - min);
    int r1 = min + rnd.nextInt(max - min);
    int r2 = min + rnd.nextInt(max - min);
    int r3 = min + rnd.nextInt(max - min);

    return "User$r$r1$r2$r3";
  }
}
