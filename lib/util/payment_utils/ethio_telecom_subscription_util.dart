import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class EthioTelecomSubscriptionUtil {
  static bool doesUserSubStatusExists() {
    return AppHiveBoxes.instance.subscriptionBox.containsKey(
      AppValues.localSubscriptionUserStatusKey,
    );
  }

  static Future<void> storeUserLocalSubStatus(
      LocalUserSubscriptionStatus localUserSubscriptionStatus) async {
    await AppHiveBoxes.instance.subscriptionBox.put(
      AppValues.localSubscriptionUserStatusKey,
      EnumToString.convertToString(localUserSubscriptionStatus),
    );
  }

  static LocalUserSubscriptionStatus? getUserSavedLocalSubStatus() {
    if (doesUserSubStatusExists()) {
      return EnumToString.fromString(
        LocalUserSubscriptionStatus.values,
        AppHiveBoxes.instance.subscriptionBox.get(
          AppValues.localSubscriptionUserStatusKey,
        ),
      )!;
    }
    return null;
  }
}
