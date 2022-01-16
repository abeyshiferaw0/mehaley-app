import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:permission_handler/permission_handler.dart';

part 'app_start_event.dart';
part 'app_start_state.dart';

class AppStartBloc extends Bloc<AppStartEvent, AppStartState> {
  AppStartBloc() : super(AppStartInitial());

  @override
  Stream<AppStartState> mapEventToState(
    AppStartEvent event,
  ) async* {
    if (event is IsAppFirstLaunchEvent) {
      //CHECK IF APP IS FIRST TIME
      final bool contains = AppHiveBoxes.instance.appMiscBox.containsKey(
        AppValues.isFirstTimeKey,
      );
      if (contains) {
        final bool isFirstTime = AppHiveBoxes.instance.appMiscBox.get(
          AppValues.isFirstTimeKey,
        );
        yield IsAppFirstLaunchState(isFirstTime: isFirstTime);
      } else {
        yield IsAppFirstLaunchState(isFirstTime: true);
      }

      ///SET IS FIRST HIVE TO FALSE
      this.add(
        SetAppFirstLaunchEvent(isFirstTime: false),
      );
    } else if (event is SetAppFirstLaunchEvent) {
      await AppHiveBoxes.instance.appMiscBox.put(
        AppValues.isFirstTimeKey,
        event.isFirstTime,
      );
      yield IsAppFirstLaunchState(isFirstTime: event.isFirstTime);
    } else if (event is SetNotificationPermissionShownDateEvent) {
      AppHiveBoxes.instance.settingsBox.put(
        AppValues.notificationPermissionShownDateKey,
        event.date.millisecondsSinceEpoch,
      );
    } else if (event is ShouldShowNotificationPermissionEvent) {
      ///FIRST CHECK IF IOS
      if (Platform.isIOS) {
        ///THEN CHECK IF NOTIFICATION IS DENIED
        var notificationStatus = await Permission.notification.status;
        if (notificationStatus.isDenied ||
            notificationStatus.isPermanentlyDenied) {
          ///THEN CHECK LAST NOTIFICATION SHOWN DATE (MUST BE > 3 DAYS)
          if (isLastPermissionNotiMoreThan3Days()) {
            yield ShowNotificationPermissionState(shouldShow: true);
          } else {
            yield ShowNotificationPermissionState(shouldShow: false);
          }
        } else {
          yield ShowNotificationPermissionState(shouldShow: false);
        }
      } else {
        yield ShowNotificationPermissionState(shouldShow: false);
      }
    } else if (event is ShouldShowSubscribeDialogEvent) {
      ///CHECK IF ACTIVE SUBSCRIPTION
      bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();

      ///Check Is Iap Available
      bool isIapAvailable = PagesUtilFunctions.isIapAvailable();

      ///CHECK IF LAST SHOWN IS 7 DAYS A GO
      bool isLastSubDialogMoreThan7Days = isLastSubscriptionMoreThan7Days();
      if (isIapAvailable) {
        if (!isUserSubscribed) {
          if (isLastSubDialogMoreThan7Days) {
            setLastSubscriptionMoreThan7Days();
            yield ShowSubscribeDialogState(shouldShow: true);
          }
        }
      }
    }
  }

  bool isLastPermissionNotiMoreThan3Days() {
    if (AppHiveBoxes.instance.settingsBox.containsKey(
      AppValues.notificationPermissionShownDateKey,
    )) {
      ///GET THE NUMBER OF DAYS BETWEEN NOTIFICATION SHOWN
      int preDateInMilliSeconds = AppHiveBoxes.instance.settingsBox.get(
        AppValues.notificationPermissionShownDateKey,
      );
      DateTime preDateTime = DateTime.fromMillisecondsSinceEpoch(
        preDateInMilliSeconds,
      );
      int diffDays = DateTime.now().difference(preDateTime).inDays;
      return diffDays > 3 ? true : false;
    } else {
      return true;
    }
  }

  bool isLastSubscriptionMoreThan7Days() {
    if (AppHiveBoxes.instance.settingsBox.containsKey(
      AppValues.dialogSubscribeShownDateKey,
    )) {
      ///GET THE NUMBER OF DAYS BETWEEN NOTIFICATION SHOWN
      int preDateInMilliSeconds = AppHiveBoxes.instance.settingsBox.get(
        AppValues.dialogSubscribeShownDateKey,
      );
      DateTime preDateTime = DateTime.fromMillisecondsSinceEpoch(
        preDateInMilliSeconds,
      );
      int diffDays = DateTime.now().difference(preDateTime).inDays;
      return diffDays > 6 ? true : false;
    } else {
      return true;
    }
  }

  setLastSubscriptionMoreThan7Days() {
    AppHiveBoxes.instance.settingsBox.put(
      AppValues.dialogSubscribeShownDateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
