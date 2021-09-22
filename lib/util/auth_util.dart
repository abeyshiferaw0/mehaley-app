import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
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
}
