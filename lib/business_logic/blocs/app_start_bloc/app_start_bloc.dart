import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
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
      final bool contains = AppHiveBoxes.instance.userBox.containsKey(
        AppValues.isFirstTimeKey,
      );
      if (contains) {
        final bool isFirstTime = AppHiveBoxes.instance.userBox.get(
          AppValues.isFirstTimeKey,
        );
        yield IsAppFirstLaunchState(isFirstTime: isFirstTime);
      } else {
        yield IsAppFirstLaunchState(isFirstTime: true);
      }
    } else if (event is SetAppFirstLaunchEvent) {
      AppHiveBoxes.instance.userBox.put(
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
          if (isLastNotiMoreThan3Days()) {
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
    }
  }

  bool isLastNotiMoreThan3Days() {
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
}
