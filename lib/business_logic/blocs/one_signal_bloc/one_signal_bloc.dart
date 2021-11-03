import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/config/enums.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'one_signal_event.dart';
part 'one_signal_state.dart';

class OneSignalBloc extends Bloc<OneSignalEvent, OneSignalState> {
  OneSignalBloc() : super(OneSignalInitial());

  @override
  Stream<OneSignalState> mapEventToState(OneSignalEvent event) async* {
    if (event is SetNotificationTagEvent) {
      yield OneSignalTagAdding();
      OneSignal.shared
          .sendTag(
            EnumToString.convertToString(event.appUserNotificationTypes),
            getChangedNotificationValue(
              event.appUserNotificationTypes,
              event.notificationTags,
            ),
          )
          .then((tagsSent) => {this.add(SetNotificationTagSuccessEvent())})
          .catchError((e) {
        this.add(SetNotificationTagErrorEvent(error: e.toString()));
      });
    } else if (event is SetNotificationTagSuccessEvent) {
      yield OneSignalTagAdded();
    } else if (event is SetNotificationTagErrorEvent) {
      yield OneSignalTagAddingError(error: event.error);
    }
  }

  String getChangedNotificationValue(
    AppUserNotificationTypes appUserNotificationTypes,
    Map<String, dynamic> notificationTags,
  ) {
    ///IF NOTIFICATION FOR THIS ENUM IS ENABLED PREVIOUSLY TURN OFF AND VISE VERSA
    if (notificationTags.containsKey(
      EnumToString.convertToString(appUserNotificationTypes),
    )) {
      String val = notificationTags[
          EnumToString.convertToString(appUserNotificationTypes)];
      if (int.parse(val) == 1) {
        return "0";
      }
      return "1";
    }
    return "1";
  }
}
